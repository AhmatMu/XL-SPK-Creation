//Class to deserialize the response from Tooling API query
public class ApexDependencyWrapper {
    public List<DependencyRecords> records {get; set;}
    public class DependencyRecords{
        //class being referred to
        public String RefMetadataComponentName {get; set;}
        //class relying on the above
        public String MetadataComponentName {get; set;}
    }
}