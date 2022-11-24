import { api, LightningElement, track, wire} from 'lwc';

const CSS_CLASS = "modal-hidden";

export default class PokemonModalComponent extends LightningElement {

    @api hpstat
    @api defensestat
    @api speedstat
    @api attackstat
    @api pokeId
    @api name
    @api height
    @api weight
    @api sprite
    @api type

    handleDialogClose(){
        const closeEvent = new CustomEvent('close');
        this.dispatchEvent(closeEvent);
    }

}