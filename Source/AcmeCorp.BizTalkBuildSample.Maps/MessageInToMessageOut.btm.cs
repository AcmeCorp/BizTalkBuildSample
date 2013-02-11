namespace AcmeCorp.BizTalkBuildSample.Maps {
    
    
    [Microsoft.XLANGs.BaseTypes.SchemaReference(@"AcmeCorp.BizTalkBuildSample.Schemas.MessageIn", typeof(global::AcmeCorp.BizTalkBuildSample.Schemas.MessageIn))]
    [Microsoft.XLANGs.BaseTypes.SchemaReference(@"AcmeCorp.BizTalkBuildSample.Schemas.MessageOut", typeof(global::AcmeCorp.BizTalkBuildSample.Schemas.MessageOut))]
    public sealed class MessageInToMessageOut : global::Microsoft.XLANGs.BaseTypes.TransformBase {
        
        private const string _strMap = @"<?xml version=""1.0"" encoding=""UTF-16""?>
<xsl:stylesheet xmlns:xsl=""http://www.w3.org/1999/XSL/Transform"" xmlns:msxsl=""urn:schemas-microsoft-com:xslt"" xmlns:var=""http://schemas.microsoft.com/BizTalk/2003/var"" exclude-result-prefixes=""msxsl var s0"" version=""1.0"" xmlns:ns0=""http://schemas.AcmeCorp.com/BizTalkBuildSample/MessageOut"" xmlns:s0=""http://schemas.AcmeCorp.com/BizTalkBuildSample/MessageIn"">
  <xsl:output omit-xml-declaration=""yes"" method=""xml"" version=""1.0"" />
  <xsl:template match=""/"">
    <xsl:apply-templates select=""/s0:Root"" />
  </xsl:template>
  <xsl:template match=""/s0:Root"">
    <ns0:Root>
      <ValueOut>
        <xsl:value-of select=""ValueIn/text()"" />
      </ValueOut>
    </ns0:Root>
  </xsl:template>
</xsl:stylesheet>";
        
        private const string _strArgList = @"<ExtensionObjects />";
        
        private const string _strSrcSchemasList0 = @"AcmeCorp.BizTalkBuildSample.Schemas.MessageIn";
        
        private const global::AcmeCorp.BizTalkBuildSample.Schemas.MessageIn _srcSchemaTypeReference0 = null;
        
        private const string _strTrgSchemasList0 = @"AcmeCorp.BizTalkBuildSample.Schemas.MessageOut";
        
        private const global::AcmeCorp.BizTalkBuildSample.Schemas.MessageOut _trgSchemaTypeReference0 = null;
        
        public override string XmlContent {
            get {
                return _strMap;
            }
        }
        
        public override string XsltArgumentListContent {
            get {
                return _strArgList;
            }
        }
        
        public override string[] SourceSchemas {
            get {
                string[] _SrcSchemas = new string [1];
                _SrcSchemas[0] = @"AcmeCorp.BizTalkBuildSample.Schemas.MessageIn";
                return _SrcSchemas;
            }
        }
        
        public override string[] TargetSchemas {
            get {
                string[] _TrgSchemas = new string [1];
                _TrgSchemas[0] = @"AcmeCorp.BizTalkBuildSample.Schemas.MessageOut";
                return _TrgSchemas;
            }
        }
    }
}
