require 'helper'

describe SilverPop::Client::Reporting do
  before do
    @client = SilverPop.new({access_token: "abc123",url: 'https://api1.silverpop.com'})
  end

  describe ".get_sent_mailings_for_org" do
    it "returns the mailingId for the given dates" do
      stub_post("/XMLAPI?access_token=abc123").
        with(:body => "<Envelope><Body><GetSentMailingsForOrg><DATE_START>1/1/2014 00:00:00</DATE_START><DATE_END>1/2/2014 23:59:59</DATE_END></GetSentMailingsForOrg></Body></Envelope>").
        to_return(:status => 200, :body => fixture('sent_mailings_org.xml'), :headers => {'Content-type' => "text/xml"})

      resp = @client.get_sent_mailings_for_org("1/1/2014 00:00:00", "1/2/2014 23:59:59")
      resp.Envelope.Body.RESULT.Mailing[0].MailingId.should eql "5758"
    end

    it "returns the mailingId for the given dates when passing an option" do
      stub_post("/XMLAPI?access_token=abc123").
        with(:body => "<Envelope><Body><GetSentMailingsForOrg><PRIVATE/><DATE_START>1/1/2014 00:00:00</DATE_START><DATE_END>1/2/2014 23:59:59</DATE_END></GetSentMailingsForOrg></Body></Envelope>").
        to_return(:status => 200, :body => fixture('sent_mailings_org.xml'), :headers => {'Content-type' => "text/xml"})

      resp = @client.get_sent_mailings_for_org("1/1/2014 00:00:00", "1/2/2014 23:59:59", {PRIVATE: nil})
      resp.Envelope.Body.RESULT.Mailing[0].MailingId.should eql "5758"
    end

    it "returns the SentMailingCount" do
      stub_post("/XMLAPI?access_token=abc123").
        with(:body => "<Envelope><Body><GetSentMailingsForOrg><MAILING_COUNT_ONLY/><DATE_START>1/1/2014 00:00:00</DATE_START><DATE_END>1/2/2014 23:59:59</DATE_END></GetSentMailingsForOrg></Body></Envelope>").
        to_return(:status => 200, :body => "<Envelope><Body><RESULT><SUCCESS>TRUE</SUCCESS><SentMailingsCount>5758</SentMailingsCount></RESULT></Body></Envelope>", :headers => {'Content-type' => "text/xml"})

      resp = @client.get_sent_mailings_for_org("1/1/2014 00:00:00", "1/2/2014 23:59:59", {MAILING_COUNT_ONLY: nil})
      resp.Envelope.Body.RESULT.SentMailingsCount.should eql "5758"
    end

  end

  describe ".get_aggregate_tracking_for_org" do
    it "returns the mailingId for the given dates" do
      stub_post("/XMLAPI?access_token=abc123").
        with(:body => "<Envelope><Body><GetAggregateTrackingForOrg><DATE_START>01/01/2014 00:00:00</DATE_START><DATE_END>01/02/2014 23:59:59</DATE_END></GetAggregateTrackingForOrg></Body></Envelope>").
        to_return(:status => 200, :body => fixture('aggregate_tracking_org.xml'), :headers => {'Content-type' => "text/xml"})

      resp = @client.get_aggregate_tracking_for_org("01/01/2014 00:00:00", "01/02/2014 23:59:59")
      resp.Envelope.Body.RESULT.Mailing[0].MailingId.should eql "21397697"
    end

    it "returns the mailingId for the given dates when passing an option" do
      stub_post("/XMLAPI?access_token=abc123").
        with(:body => "<Envelope><Body><GetAggregateTrackingForOrg><TOP_DOMAIN/><DATE_START>01/01/2014 00:00:00</DATE_START><DATE_END>01/02/2014 23:59:59</DATE_END></GetAggregateTrackingForOrg></Body></Envelope>").
        to_return(:status => 200, :body => fixture('aggregate_tracking_org.xml'), :headers => {'Content-type' => "text/xml"})

      resp = @client.get_aggregate_tracking_for_org("01/01/2014 00:00:00", "01/02/2014 23:59:59", {TOP_DOMAIN: nil})
      resp.Envelope.Body.RESULT.Mailing[0].MailingId.should eql "21397697"
    end

    it "returns the NumSent for first mailing" do
      stub_post("/XMLAPI?access_token=abc123").
        with(:body => "<Envelope><Body><GetAggregateTrackingForOrg><TOP_DOMAIN/><DATE_START>01/01/2014 00:00:00</DATE_START><DATE_END>01/02/2014 23:59:59</DATE_END></GetAggregateTrackingForOrg></Body></Envelope>").
        to_return(:status => 200, :body => fixture('aggregate_tracking_org.xml'), :headers => {'Content-type' => "text/xml"})

      resp = @client.get_aggregate_tracking_for_org("01/01/2014 00:00:00", "01/02/2014 23:59:59", {TOP_DOMAIN: nil})
      resp.Envelope.Body.RESULT.Mailing[0].NumSent.should eql "100978"
    end

    it "returns the first domain for first mailing" do
      stub_post("/XMLAPI?access_token=abc123").
        with(:body => "<Envelope><Body><GetAggregateTrackingForOrg><TOP_DOMAIN/><DATE_START>01/01/2014 00:00:00</DATE_START><DATE_END>01/02/2014 23:59:59</DATE_END></GetAggregateTrackingForOrg></Body></Envelope>").
        to_return(:status => 200, :body => fixture('aggregate_tracking_org.xml'), :headers => {'Content-type' => "text/xml"})

      resp = @client.get_aggregate_tracking_for_org("01/01/2014 00:00:00", "01/02/2014 23:59:59", {TOP_DOMAIN: nil})
      resp.Envelope.Body.RESULT.TopDomains[0].TopDomain[0].Domain.should eql "aol.com"
    end

  end

  describe ".raw_recipient_data_export" do
    it "should return true when passing a MAILING_ID" do
      stub_post("/XMLAPI?access_token=abc123").
        with(:body => "<Envelope><Body><RawRecipientDataExport><MAILING><MAILING_ID>1234</MAILING_ID></MAILING></RawRecipientDataExport></Body></Envelope>").
          to_return(:status => 200, :body => fixture("reporting.xml"), :headers => {'Content-type' => "text/xml"})


      resp = @client.raw_recipient_data_export({MAILING_ID: 1234})
      resp.Envelope.Body.RESULT.SUCCESS.should eql "TRUE"
    end

    it "should return true when passing a REPORT_ID" do
      stub_post("/XMLAPI?access_token=abc123").
        with(:body => "<Envelope><Body><RawRecipientDataExport><MAILING><REPORT_ID>5678</REPORT_ID></MAILING></RawRecipientDataExport></Body></Envelope>").
          to_return(:status => 200, :body => fixture("reporting.xml"), :headers => {'Content-type' => "text/xml"})


      resp = @client.raw_recipient_data_export({REPORT_ID: 5678})
      resp.Envelope.Body.RESULT.SUCCESS.should eql "TRUE"
    end

    it "should return true when passing a EVENT_DATE_START and EVENT_DATE_END" do
      stub_post("/XMLAPI?access_token=abc123").
         with(:body => "<Envelope><Body><RawRecipientDataExport><EVENT_DATE_START>1/1/2013</EVENT_DATE_START><EVENT_DATE_END>7/1/2013</EVENT_DATE_END></RawRecipientDataExport></Body></Envelope>").
          to_return(:status => 200, :body => fixture("reporting.xml"), :headers => {'Content-type' => "text/xml"})


      resp = @client.raw_recipient_data_export({EVENT_DATE_START: "1/1/2013", EVENT_DATE_END: "7/1/2013"})
      resp.Envelope.Body.RESULT.SUCCESS.should eql "TRUE"
    end

    it "should return true when passing options" do
      stub_post("/XMLAPI?access_token=abc123").
        with(:body => "<Envelope><Body><RawRecipientDataExport><MAILING><MAILING_ID>1234</MAILING_ID></MAILING><MOVE_TO_FTP/></RawRecipientDataExport></Body></Envelope>").
          to_return(:status => 200, :body => fixture("reporting.xml"), :headers => {'Content-type' => "text/xml"})

      resp = @client.raw_recipient_data_export({MAILING_ID: 1234},{MOVE_TO_FTP: nil})
      resp.Envelope.Body.RESULT.SUCCESS.should eql "TRUE"
    end

    it "should return true when passing extra columns to export" do
      stub_post("/XMLAPI?access_token=abc123").
        with(:body => "<Envelope><Body><RawRecipientDataExport><MAILING><MAILING_ID>1234</MAILING_ID></MAILING><COLUMNS><COLUMN><NAME>CustomerID</NAME></COLUMN><COLUMN><NAME>Address</NAME></COLUMN></COLUMNS></RawRecipientDataExport></Body></Envelope>").
          to_return(:status => 200, :body => fixture("reporting.xml"), :headers => {'Content-type' => "text/xml"})

      resp = @client.raw_recipient_data_export({MAILING_ID: 1234},{}, ["CustomerID", "Address"])
      resp.Envelope.Body.RESULT.SUCCESS.should eql "TRUE"
    end
  end

  describe ".get_job_status" do
    it "returns the job_status for the given job_id" do
      stub_post("/XMLAPI?access_token=abc123").
        with(:body => "<Envelope><Body><GetJobStatus><JOB_ID>1234</JOB_ID></GetJobStatus></Body></Envelope>").
          to_return(:status => 200, :body => '<Envelope><Body><RESULT><SUCCESS>TRUE</SUCCESS>
                    <JOB_ID>1234</JOB_ID><JOB_STATUS>COMPLETE</JOB_STATUS>
                    <JOB_DESCRIPTION> Creating new contact source, Master Database</JOB_DESCRIPTION>
                    <PARAMETERS><PARAMETER><NAME>NOT_ALLOWED</NAME><VALUE>0</VALUE></PARAMETER></PARAMETERS>
                    </RESULT></Body></Envelope>', :headers => {'Content-type' => "text/xml"})


      resp = @client.get_job_status(1234)
      resp.Envelope.Body.RESULT.JOB_STATUS.should eql "COMPLETE"
    end
  end

end
