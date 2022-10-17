public with sharing class PokeBatch implements Database.Batchable<Object>, Database.AllowsCallouts {
    
    private List<Object> pokemon;

    public PokeBatch (List<Object> pokemon){
        this.pokemon = pokemon;
    }

    public Iterable<Object> start(Database.BatchableContext bc) {
        return this.pokemon;
    }

    public void execute(Database.BatchableContext bc, List<Object> records){



        Map<String,Object> pokeData = new Map<String,Object>();
        List<Pokemon__c> pokemonsToInsert = new List<Pokemon__c>();
        //PokemonDetailWrapper results;
        Map<String, Object> sprites = new Map<String, Object>();
        
        Map<String, Object> HPStat = new Map<String, Object>();
        Map<String, Object> DFStat = new Map<String, Object>();
        Map<String, Object> ATStat = new Map<String, Object>();
        Map<String, Object> SPStat = new Map<String, Object>();

        List<Object> stats = new List<Object>();
        Map<String, Object> statNames = new Map<String, Object>();
        
        Map<String,Object> results = new Map<String,Object>();
        
        for(Object obj : records){

            pokeData = (Map<String,Object>)obj;

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint((String)pokeData.get('url'));
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            
            //results = PokemonDetailWrapper.parse(response.getBody());
            
            
            //HttpResponse response = GenericHttpCallouts.Request((String)pokeData.get('url'),'GET');
            results = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());

            sprites = (Map<String,Object>) results.get('sprites');

            stats = (List<Object>) results.get('stats');

            HPStat = (Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(stats[0]));
            DFStat = (Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(stats[2]));
            ATStat = (Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(stats[1]));
            SPStat = (Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(stats[5]));

            
           
            /*for (Object stat : stats) {

                statNames = (Map<String,Object>) statsElements.get('stat');
            } */
            /* pokemonsToInsert.add(new Pokemon__c(
                Name = results.name,
                height__c = results.height,
                weight__c = results.weight,
                Id__c = String.valueOf(results.id)
            )); */

            
            //System.debug(results);
            pokemonsToInsert.add(new Pokemon__c(
                Name = (String) results.get('name'),
                height__c = (Integer) results.get('height'),
                weight__c = (Integer) results.get('weight'),
                Id__c = String.valueOf(results.get('id')),
                Sprite__c = (String) sprites.get('front_default'),
                Hp__c = (Integer) HPStat.get('base_stat'),
                Attack__c = (Integer) ATStat.get('base_stat'),
                Defense__c = (Integer) DFStat.get('base_stat'),
                Speed__c = (Integer) SPStat.get('base_stat')
                
            ));   
        }

        try{

            if(pokemonsToInsert.size()>0){
                insert pokemonsToInsert; /* upsert pokemonsToInsert Id__c */
            }

        }catch(DMLException e){
            //Database.rollback(savepoint);
        }
        
        
    }

    public void finish(Database.BatchableContext bc){
        
    }
}
