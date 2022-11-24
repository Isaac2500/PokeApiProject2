public class UploadUrlImage {/*
    public static void uploadImage(String imageUrl){
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint(imageUrl);
            req.setMethod('GET');
            
            Http binding = new Http();
            HttpResponse response = binding.send(req);
            blob image = response.getbodyasblob();
                        
            ContentVersion cv = new ContentVersion();
            cv.ContentLocation ='S';
            String titleExtension = imageUrl.substringAfterLast('/');
            String imageTitle = titleExtension.substringBeforeLast('.');
            cv.Title = imageTitle;
            cv.PathOnClient = titleExtension;
            cv.VersionData = image;
            insert cv;
            
            Id folderId =[SELECT Id, Name, CreatedBy.Name FROM ContentWorkspace WHERE Name = 'Asset Library' LIMIT 1].Id;
            String Verid =[Select ContentDocumentid from ContentVersion where id =: cv.id].ContentDocumentid;
            ContentDocumentLink link = new ContentDocumentLink();
            //pokemon id here for contentdocumentId
            link.ContentDocumentid = Verid;
            link.linkedEntityId = folderId;
            link.shareType = 'I';
            link.visibility = 'ALLUsers';
            insert link;
            
        } catch(exception e){
            System.debug(e.getmessage());
        }         
    }*/
    public static ContentVersion createContentVersion(String imageUrl, String imageName){
        ContentVersion cv = new ContentVersion();
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(imageUrl);
            req.setMethod('GET');
            
            Http binding = new Http();
            HttpResponse response = binding.send(req);
            blob image = response.getbodyasblob();
                        
            cv.ContentLocation ='S';
            String titleExtension = imageUrl.substringAfterLast('/');
            cv.Title = imageName;
            cv.PathOnClient = titleExtension;
            cv.VersionData = image;
        } catch(exception e){
            System.debug(e.getmessage());
        }
        return cv;
    }
    public static void createDocumentLink(List<ContentVersion> versionList){
        try {
            Id folderId =[SELECT Id, Name, CreatedBy.Name FROM ContentWorkspace WHERE Name = 'Asset Library' LIMIT 1].Id;
            for (ContentVersion act : versionList) {
                String Verid =[Select ContentDocumentid from ContentVersion where id =: act.id].ContentDocumentid;
                ContentDocumentLink link = new ContentDocumentLink();
                //pokemon id here for contentdocumentId
                link.ContentDocumentid = Verid;
                link.linkedEntityId = folderId;
                link.shareType = 'I';
                link.visibility = 'ALLUsers';
                insert link;
            }
        } catch(exception e){
            System.debug(e.getmessage());
        }
    }
}