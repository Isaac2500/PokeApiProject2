import { LightningElement , wire, api, track} from 'lwc';
import { APPLICATION_SCOPE, MessageContext, subscribe} from 'lightning/messageService';
import POKEMON_MC from '@salesforce/messageChannel/PokemonMessageChannel__c';
import searchPokemons from '@salesforce/apex/PokemonSearchCls.searchPokemons';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getNextPageApex from "@salesforce/apex/PokemonSearchCls.GetNextPage";
import getPrevPageApex from "@salesforce/apex/PokemonSearchCls.GetPrevPage";

export default class PokemonDataTableComponent extends LightningElement {

    @wire(MessageContext)
    context

    @track pokemonList=[];
    searchKey='';
    @track pageLength = 9;
    @track page = 0;
    @track totalNumberOfPages = 0;
    @track actualPage;
    showModal = false;

    constructor(){
        super();
             
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
                    page: 0
                })
                .then(result => {
                      
                    this.pokemonList = result;
                    console.log(this.pokemonList);
                    this.totalNumberOfPages = Math.ceil(this.pokemonList.length/this.pageLength);
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
            
            searchPokemons({
                pokemonName: this.searchKey,
                pageLength: 9, 
                page: 0
            })
            .then(result => {
                  
                this.pokemonList = result;
                console.log(this.pokemonList);
                this.totalNumberOfPages = Math.ceil(this.pokemonList.length/this.pageLength);
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

        }
    }

    connectedCallback() {
        this.getMessage();
        searchPokemons({
            pokemonName: this.searchKey, 
            pageLength: this.pageLength, 
            page: this.page
        })
        .then(result => {
              
            this.pokemonList = result;
            console.log(result);
            this.totalNumberOfPages = Math.ceil(this.pokemonList.length/this.pageLength);
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
    }

    GetNextPage(){
        this.page = this.page + 1;
            getNextPageApex({pokemonName: this.searchKey, pageLength: this.pageLength, page: this.page}).then(result => {  
                this.pokemonList = result;
                console.log(this.pokemonList)
            });
            
    }   

    GetPrevPage(){
        console.log(this.pokemonList)
        if(this.page >= 1){
            this.page = this.page - 1;
            getPrevPageApex({pokemonName: this.searchKey, pageLength: this.pageLength, page: this.page}).then(result => {  
                this.pokemonList = result;
                console.log(this.pokemonList)
            });
        }
    }

    handleShowModal(event) {
        let pokemon = this.pokemonList.filter(e => e.Id__c == event.currentTarget.dataset.id);
        this.pokeId = pokemon[0].Id__c;
        this.sprite = pokemon[0].Sprite__c;
        this.name = pokemon[0].Name;
        this.weight = pokemon[0].weight__c;
        this.height = pokemon[0].height__c;
        this.hp = pokemon[0].Hp__c;
        this.speed= pokemon[0].Speed__c;
        this.defense = pokemon[0].Defense__c;
        this.attack = pokemon[0].Attack__c;
        this.type = pokemon[0].Type__c;
        this.showModal = true;
    }

    closeModal(){
        this.showModal = false;
    }

    calculatePagination(){
        this.totalNumberOfPages = Math.ceil(this.pokemonList.length/this.pageLength);
        console.log(Math.ceil(this.pokemonList.length/this.pageLength));
    }
}