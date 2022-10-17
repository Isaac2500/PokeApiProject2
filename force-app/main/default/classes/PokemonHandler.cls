public with sharing class PokemonHandler {
    public PokemonHandler() {

    }

    public static void PokemonCallout(){
        HttpResponse response = GenericHttpCallouts.Request('https://pokeapi.co/api/v2/pokemon/?limit=1154','GET');

        Map<String,Object> results = new Map<String,Object>();
        List<Object> listResponse = new List<Object>();

        if(response.getStatusCode() == 200 && response.getBody() != null){
            results = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            listResponse = (List<Object>) results.get('results');
            //System.debug(listResponse);
            Database.executeBatch(new PokeBatch(listResponse),100);
        }

    }

    /*public class PokeData {
        public string name;
        public string url;
                
    }*/

}