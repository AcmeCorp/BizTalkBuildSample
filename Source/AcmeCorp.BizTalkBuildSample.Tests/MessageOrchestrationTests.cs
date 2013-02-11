﻿namespace AcmeCorp.BizTalkBuildSample.Tests
{
    using System.Collections.ObjectModel;
    using System.Reflection;
    using System.Xml;

    using BizUnit.TestSteps.Common;
    using BizUnit.Xaml;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class MessageOrchestrationTests
    {
        private const int TwentySecondsInMilliseconds = 20000;

        [TestMethod]
        public void IntegrationTest_With_Valid_Message_In()
        {
            TestCase testCase = new TestCase { Name = MethodBase.GetCurrentMethod().Name };
            XmlDocument messageBody = new XmlDocument();
            messageBody.LoadXml(@"<ns0:Root xmlns:ns0='http://schemas.AcmeCorp.com/BizTalkBuildSample/MessageIn'><ValueIn>ValueIn_0</ValueIn></ns0:Root>");
            MsmqWriteStep msmqWriteStep = new MsmqWriteStep
                {
                    FailOnError = true,
                    Name = "Write 'MessageIn' message to MSMQ.",
                    QueuePath = ".\\private$\\AcmeCorp.BizTalkBuildSample.MessageIn",
                    MessageBodyContent = messageBody
                };
            testCase.ExecutionSteps.Add(msmqWriteStep);
            XPathDefinition xpathDefinition = new XPathDefinition { Value = "ValueIn_0", XPath = "/*[local-name()='Root']/*[local-name()='ValueOut']" };
            XPathValidationStep xpathValidationStep = new XPathValidationStep();
            xpathValidationStep.XPathValidations.Add(xpathDefinition);
            MsmqReadStep msmqReadStep = new MsmqReadStep
                {
                    FailOnError = true, 
                    Name = "Read 'MessageOut' message from MSMQ.", 
                    QueuePath = ".\\private$\\AcmeCorp.BizTalkBuildSample.MessageOut",
                    TimeoutInMilliseconds = TwentySecondsInMilliseconds
                };
            msmqReadStep.SubSteps = new Collection<SubStepBase>();
            msmqReadStep.SubSteps.Add(xpathValidationStep);
            testCase.ExecutionSteps.Add(msmqReadStep);
            BizUnit.BizUnit bizUnit = new BizUnit.BizUnit(testCase);
            bizUnit.RunTest();
        }
    }
}
