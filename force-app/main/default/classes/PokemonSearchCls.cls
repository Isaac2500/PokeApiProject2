public with sharing class PokemonSearchCls {
    public PokemonSearchCls() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> searchPokemons(string pokemonName, integer pageLength, integer page){
        string query = 'SELECT Id__c, Name FROM Pokemon__c'; 
        string keySearch = '%'+pokemonName+'%';
        
        /* if(pokemonName.isNotBlank()){
            
        } */

        integer offset = pageLength * page;
        List<Pokemon__c> pokemonListRecords = new List<Pokemon__c>();
        try {
            for(Pokemon__c pokemon : [SELECT Id__c, Name, Sprite__c, Defense__c, height__c, weight__c, Speed__c, Hp__c, Attack__c FROM Pokemon__c WHERE Name LIKE :keySearch LIMIT :pageLength OFFSET :offset]){
                pokemonListRecords.add(pokemon);
            }

            if (pokemonListRecords.size() == 0) {
                throw new AuraHandledException('No record found...');
            }else{
                return pokemonListRecords;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> GetNextPage(string pokemonName, integer pageLength, integer page) {
        integer offset = pageLength * page;
        string keySearch = '%'+pokemonName+'%';
        List<Pokemon__c> pokemons = [SELECT Id__c, Name, Sprite__c, Defense__c, height__c, weight__c, Speed__c, Hp__c, Attack__c FROM Pokemon__c WHERE Name LIKE :keySearch LIMIT :pageLength OFFSET :offset];
        return pokemons;
    }       

    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> GetPrevPage(string pokemonName, integer pageLength, integer page) {
        integer offset = pageLength * page;
        string keySearch = '%'+pokemonName+'%';
        List<Pokemon__c> pokemons = [SELECT Id__c, Name, Sprite__c, Defense__c, height__c, weight__c, Speed__c, Hp__c, Attack__c FROM Pokemon__c WHERE Name LIKE :keySearch LIMIT :pageLength OFFSET :offset];
        return pokemons;
    }
    
    @AuraEnabled
    public static Pokemon__c getPokemonModal(string id){
        try {
            Pokemon__c pk = [SELECT Id__c, Name, Sprite__c, Defense__c, height__c, weight__c, Speed__c, Hp__c, Attack__c FROM Pokemon__c WHERE Id__c =:id];
            return pk;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
