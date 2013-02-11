// --------------------------------------------------------------------------------------------------------------------
// <copyright file="AssemblyInfo.cs" company="Beazley">
//   Copyright Beazley. All rights reserved.
// </copyright>
// <summary>
//   AssemblyInfo.cs
// </summary>
// --------------------------------------------------------------------------------------------------------------------

using System;
using System.Diagnostics.CodeAnalysis;
using System.Reflection;
using System.Resources;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

using Microsoft.BizTalk.XLANGs.BTXEngine;
using Microsoft.XLANGs.BaseTypes;

[assembly: AssemblyDescription("AcmeCorp.BizTalkBuildSample.Schemas")]
[assembly: AssemblyTitle("AcmeCorp.BizTalkBuildSample.Schemas")]
[assembly: CLSCompliant(false)]
[assembly: ComVisible(false)]
[assembly: Guid("d993af83-b07f-4a3e-bb7a-f08d92c3060f")]
[assembly: NeutralResourcesLanguage("en-GB")]
[assembly: SuppressMessage("Microsoft.Design", "CA2210:AssembliesShouldHaveValidStrongNames")] // Assembly is delay signed.
[assembly: SuppressMessage("Microsoft.Design", "CA1016:MarkAssembliesWithAssemblyVersion")] // Development version is "0.0.0.0"
[assembly: SuppressMessage("Microsoft.Usage", "CA2243:AttributeStringLiteralsShouldParseCorrectly")] // "AssemblyInformationalVersion" is a string
[assembly: BizTalkAssembly(typeof(BTXService))]
