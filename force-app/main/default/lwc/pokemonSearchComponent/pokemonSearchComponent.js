import { LightningElement, wire, track } from 'lwc';
import searchPokemons from '@salesforce/apex/PokemonSearchCls.searchPokemons';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import  POKEMON_MC  from '@salesforce/messageChannel/PokemonMessageChannel__c';
import { MessageContext, publish } from 'lightning/messageService';

export default class PokemonSearchComponent extends LightningElement {

    @wire(MessageContext)
    context


    /* @track pokemonList=[]; */
    searchValue = '';
    
    // update searchValue var when input field value change
    /* searchKeyword(event) {
        this.searchValue = event.target.value;
    } */

    publishMessage(event){
        const message = { inputValue: this.searchValue };
        console.log(message);
        publish(this.context, POKEMON_MC, message)
    }

    
    handleSearchKeyword() {

         /* if (this.searchValue !== '') {
            searchPokemons({
                    pokemonName: this.searchValue
                })
                .then(result => {
                      
                    this.pokemonList = result;
                    this.publishMessage();
                })
                .catch(error => {
                   
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        message: error.body.message,
                    });
                    this.dispatchEvent(event);
                      
                    this.pokemonList = null;
                });
        } else {
            // fire toast event if input field is blank
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'Search text missing..',
            });
            this.dispatchEvent(event);
        } */ 
    }

    searchHandlerKeyUp(event) {
        this.searchValue = event.detail.value;

        /* try {
            clearTimeout(this.searchTimeout);
            this.searchTimeout = setTimeout(() => {
                try {
                    //this.searchedValue = (event.detail.value).toLowerCase();
                    this.searchValue = event.detail.value;
                } catch (error) {
                    console.error('existe un error' + error)
                }
            }, 1200);
        } catch (error) {
            console.error(error)
        } */


    }

    /* pokemonToSearch = '';
    @track pokemonList = [];
    @wire(searchPokemons,{pokemonName: this.pokemonToSearch})

    retrievePokemon({error,data}){
        if(data){
            this.pokemonList = data;    
        }else if(error){

        }
    } */ 
}