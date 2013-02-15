function Generate-ConfigurationFiles (
    [string]$dictionaryFilePath = $(throw '$dictionaryFilePath is a required parameter'),
    [string]$templatesDirectoryPath = $(throw '$templatesDirectoryPath is a required parameter'),
    [string]$targetDirectoryPath = $(throw '$targetDirectoryPath is a required parameter'),
    [bool]$matchFilesInTargetDirectory = $false,
    [switch]$verbose=$false,
    [switch]$whatIf=$false,
	[string]$versionNumber) {

    # Test the existence of the dictionary
    [bool]$dictionaryExists = Test-Path $dictionaryFilePath
    if (!$dictionaryExists)
    {
        throw "The path of '",$dictionaryFilePath,"' given for the dictionary was not valid, the file was not found."
    }
    Write-Verbose -verbose:$verbose ("DictionaryFilePath={0}" -F [string] $dictionaryFilePath)

    # Test the existence of the templates directory
    [bool]$templatesDirectoryPathExists = Test-Path $templatesDirectoryPath
    if (!$templatesDirectoryPathExists)
    {
        throw "The path of '",$templatesDirectoryPath,"' given for the templates directory was not valid, the file was not found."
    }
    Write-Verbose -verbose:$verbose ("TemplatesDirectoryPath={0}" -F [string] $templatesDirectoryPath)

    # Test the existence of the target directory
    [bool]$targetDirectoryPathExists = Test-Path $targetDirectoryPath
    if (!$targetDirectoryPathExists)
    {
        throw "The path of '",$targetDirectoryPath,"' given for the target directory was not valid, the file was not found."
    }
    Write-Verbose -verbose:$verbose ("TargetDirectoryPath={0}" -F [string] $targetDirectoryPath)

    # Initialise a dictionary to keep track of the matches
    $matchResults = New-Object 'System.Collections.Generic.Dictionary[string, int]'

    # Copy the templates a temporary directory
    $templatesTemporaryDirectorySuffix = [guid]::NewGuid().ToString()
    $templatesSourceFilter = Join-Path $templatesDirectoryPath "*.*"
    $templatesTemporaryDirectoryPath = Join-Path $templatesDirectoryPath $templatesTemporaryDirectorySuffix"\"
    $templatesTemporaryDirectoryAllFilesFilter = Join-Path $templatesTemporaryDirectoryPath "*.*"
    New-Item $templatesTemporaryDirectoryPath -type directory | out-null
    Copy-Item $templatesSourceFilter $templatesTemporaryDirectoryPath

    # Make the templates in the temporary directory writable (the originals are likely to have been source controlled and therefore read-only).
    foreach ($filePath in Get-ChildItem $templatesTemporaryDirectoryAllFilesFilter)   
    {
        $filePath.set_IsReadOnly($false)
    }  

    # Load the dictionary
    [xml]$dictionaryXml = Get-Content $dictionaryFilePath

    # Replace the regular expressions in each file in the temporary directory
    foreach ($filePath in Get-ChildItem $templatesTemporaryDirectoryAllFilesFilter)
    {
        $templateContent = [System.IO.File]::ReadAllText($filePath)
        foreach($entry in $dictionaryXml.ConfigurationDictionary.Entry) 
        {
            [int]$matchCount = 0;
            $regex = New-Object System.Text.RegularExpressions.Regex $entry.regularExpression, SingleLine
            $regexMatch = $regex.Match($templateContent)
            while ($regexMatch.Success)
            {
                $matchCount++;
                $regexMatch = $regexMatch.NextMatch();
            }

            [string]$replacementValue = $null;
			if ($entry.ReplacementValue.GetType().ToString() -eq "System.Xml.XmlElement")
			{
				[System.Xml.XmlElement]$replacementValueXml = $entry.ReplacementValue;
				$replacementValue = $replacementValueXml.InnerText;
			}
			else
			{
				$replacementValue = $entry.ReplacementValue;
			}

			$templateContent = $regex.Replace($templateContent, $replacementValue)
            $matchResults[$entry.regularExpression] += $matchCount;
        }

		if ($versionNumber -ne $null)
		{
			# Replace version number
			$versionRegex = New-Object System.Text.RegularExpressions.Regex "##VersionNumber##", SingleLine
			$templateContent = $versionRegex.Replace($templateContent, $versionNumber)
		}

        [System.IO.File]::WriteAllText($filePath, $templateContent);
    }

    # Assert that expected matches were made
    [bool]$expectedMatchesFailed = $false;
    foreach ($entry in $dictionaryXml.ConfigurationDictionary.Entry)
    {
        $actualMatches = $matchResults[$entry.regularExpression];
        if ($actualMatches -ne $entry.expectedMatches)
        {
            $expectedMatchesFailed = $true;
            [string]$errorMessage = "Regex:'",$entry.regularExpression,"'; Expected matches:",$entry.expectedMatches,"; Actual matches:",$actualMatches
            Write-Error $errorMessage
        }
    }

    if ($expectedMatchesFailed)
    {
        $(throw 'One or more expected matches were not met, see previous errors.')
    }

    # Copy templates to target directory
    foreach ($filePath in Get-ChildItem $templatesTemporaryDirectoryAllFilesFilter)
    {
        [string]$targetFilePath = Join-Path $targetDirectoryPath $filePath.Name
        [bool]$targetFileExists = Test-Path $targetFilePath
        if ($matchFilesInTargetDirectory -and $targetFileExists)
        {
            # Only copy files where one with the same name already exists as
            # we're only matching files in the target directory.
            Copy-Item $filePath $targetFilePath
        }
        elseif ($matchFilesInTargetDirectory -and !$targetFileExists)
        {
            # Don't copy the file as we are matching files in the target 
            # directory and a file with the same name was not found in the 
            # target directory.
            Write-Verbose -verbose:$verbose ("{0}, skipping file as a same named file was not found in the target directory and 'matchFilesInTargetDirectory={1}'" -F [string] $filePath, [string] $matchFilesInTargetDirectory)
        }
        elseif (!$matchFilesInTargetDirectory)
        {
            # Copy the file regardless as we aren't matching files in the target
            # directory.
            Copy-Item $filePath $targetFilePath
        }
    }

    # Delete the temporary directory
    Remove-Item $templatesTemporaryDirectoryPath -recurse
}
