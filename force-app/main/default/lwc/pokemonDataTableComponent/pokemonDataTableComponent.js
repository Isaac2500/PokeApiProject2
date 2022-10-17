import { LightningElement , wire, api, track} from 'lwc';
import { APPLICATION_SCOPE, MessageContext, subscribe} from 'lightning/messageService';
import POKEMON_MC from '@salesforce/messageChannel/PokemonMessageChannel__c';
import searchPokemons from '@salesforce/apex/PokemonSearchCls.searchPokemons';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import GetNextPage from "@salesforce/apex/PokemonSearchCls.GetNextPage";
import GetPrevPage from "@salesforce/apex/PokemonSearchCls.GetPrevPage";






export default class PokemonDataTableComponent extends LightningElement {

    @wire(MessageContext)
    context

    @track searchKey='';
    @track pokemonList=[];
    @track nombrepokemon = '';
    pageLength = 5;
    page = 0;

    constructor(){
        super();

        searchPokemons({
            pokemonName: this.searchKey, 
            pageLength: this.pageLength, 
            page: this.page

        })
        .then(result => {
              
            this.pokemonList = result;
            console.log(result);
        }).catch(error => {
                   
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                message: error.body.message,
            });
            this.dispatchEvent(event);
            console.log(error)  
            this.pokemonList = null;
        });

        this.template.querySelectorAll("lightning-button").forEach(element => {
            element.addEventListener("click", ()=>{
                element.show();
                console.log("modal called");
            })
        });

        
    }

    getMessage(){
        subscribe(this.context,POKEMON_MC,(message)=>{this.handleMessage(message)},{scope:APPLICATION_SCOPE})
    }

    handleMessage(message) {
      
        this.searchKey = message.inputValue;
        console.log(this.searchKey);
        if (this.searchKey !== '') {
            searchPokemons({
                    pokemonName: this.searchKey,
                    pageLength: this.pageLength, 
                    page: this.page
                })
                .then(result => {
                      
                    this.pokemonList = result;
                    console.log(this.pokemonList)
                })
                .catch(error => {
                   
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        message: error.body.message,
                    });
                    this.dispatchEvent(event);
                    console.log(error)  
                    this.pokemonList = null;
                });
        } else {
            // fire toast event if input field is blank
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'Search text missing..',
            });
            this.dispatchEvent(event);
        }


    }

    connectedCallback() {
        this.getMessage();
    }

    GetNextPage(){
        this.page = this.page + 1;
            getNextPageApex({pokemonName: this.searchKey, pageLength: this.pageLength, page: this.page}).then(result => {  
                this.pokemonList = result;
                console.log(this.pokemonList)      
            });
    }   

    GetPrevPage(){
        if(this.page >= 1){
            this.page = this.page - 1;
            getPrevPageApex({pokemonName: this.searchKey, pageLength: this.pageLength, page: this.page}).then(result => {  
                this.pokemonList = result; 
                console.log(this.pokemonList)     
            }); 
        }
    }

    handleShowModal(event) {

        let pokemon = this.pokemonList.filter(e => e.id == event.currentTarget.dataset.id );
        console.log(JSON.stringify(pokemon));
        this.nombrepokemon = pokemon[0].Name;
        
        const modal = this.template.querySelector("c-pokemon-modal-component");   
        modal.show();
        
    }

    

    
}



