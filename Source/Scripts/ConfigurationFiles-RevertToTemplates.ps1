param(
	[string]$templatesDirectoryPath = $(throw '$templatesDirectoryPath is a required parameter'),
	[string]$targetDirectoryPath = $(throw '$targetDirectoryPath is a required parameter')
	)

# Test the existence of the templates directory
[bool]$templatesDirectoryPathExists = Test-Path $templatesDirectoryPath
if (!$templatesDirectoryPathExists)
{
	throw "The path of '",$templatesDirectoryPath,"' given for the templates directory was not valid, the file was not found."
}
else
{
	Write-Host "'templatesDirectoryPath' exists and is",$templatesDirectoryPath
}

# Test the existence of the target directory
[bool]$targetDirectoryPathExists = Test-Path $targetDirectoryPath
if (!$targetDirectoryPathExists)
{
	throw "The path of '",$targetDirectoryPath,"' given for the target directory was not valid, the file was not found."
}
else
{
	Write-Host "'targetDirectoryPath' exists and is",$targetDirectoryPath
}

$templatesDirectoryAllFilesFilter = Join-Path $templatesDirectoryPath "*.*"

# Copy templates to target directory
foreach ($filePath in Get-ChildItem $templatesDirectoryAllFilesFilter)
{
	[string]$targetFilePath = Join-Path $targetDirectoryPath $filePath.Name
	[bool]$targetFileExists = Test-Path $targetFilePath
	if ($targetFileExists)
	{
		Write-Host "Copying template '"$filePath.Name"' to '"$targetDirectoryPath"'."
		Copy-Item $filePath $targetFilePath
		Set-ItemProperty $targetFilePath -name IsReadOnly -value $false
	}
	else
	{
		Write-Host "A file named '"$filePath.Name"' was not found at the target path of '"$targetDirectoryPath"' so the template is not being copied (as there is no file to revert to a template."
	}
}