public with sharing class PokeBatch implements Database.Batchable<Object>, Database.AllowsCallouts {
    
    private List<Object> pokemon;

    public PokeBatch (List<Object> pokemon){
        this.pokemon = pokemon;
    }

    public Iterable<Object> start(Database.BatchableContext bc) {
        return this.pokemon;
    }

    public void execute(Database.BatchableContext bc, List<Object> records){

        //Savepoint savepoint = Database.setSavepoint();

        Map<String,Object> pokeData = new Map<String,Object>();
        List<Pokemon__c> pokemonsToInsert = new List<Pokemon__c>();
        Map<String,Object> results = new Map<String,Object>();

        
        for(Object obj : records){

            pokeData = (Map<String,Object>)obj;

            HttpResponse response = GenericHttpCallouts.Request((String)pokeData.get('url'),'GET');
            results = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());

            //System.debug(results);
            pokemonsToInsert.add(new Pokemon__c(
                Name = (String) results.get('name'),
                height__c = (Integer) results.get('height'),
                weight__c = (Integer) results.get('weight'),
                Id__c = (Integer) results.get('Id')
            ));   
        }

        try{

            if(pokemonsToInsert.size()>0){
                insert pokemonsToInsert;
            }

        }catch(DMLException e){
            //Database.rollback(savepoint);
        }
        
        
    }

    public void finish(Database.BatchableContext bc){
        
    }
}
