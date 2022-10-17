import { api, LightningElement, track, wire} from 'lwc';

const CSS_CLASS = "modal-hidden";

export default class PokemonModalComponent extends LightningElement {
    
    showModal = false;

    @api hpstat
    @api deffensestat
    @api speedstat
    @api attackstat
    @api id
    @api name 
    @api height
    @api weight
    @api sprite

    @api show(){
        this.showModal = true;
    }

    handleDialogClose(){
        this.showModal = false;
    }
    
}