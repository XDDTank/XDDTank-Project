// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.propContainer.BaseGamePropBarView

package game.view.propContainer
{
    import flash.display.Sprite;
    import game.model.LocalPlayer;
    import ddt.events.LivingEvent;
    import ddt.events.ItemEvent;

    public class BaseGamePropBarView extends Sprite 
    {

        protected var _notExistTip:Sprite;
        protected var _itemContainer:ItemContainer;
        private var _self:LocalPlayer;

        public function BaseGamePropBarView(_arg_1:LocalPlayer, _arg_2:Number, _arg_3:Number, _arg_4:Boolean, _arg_5:Boolean, _arg_6:Boolean, _arg_7:String="")
        {
            this._self = _arg_1;
            this._itemContainer = new ItemContainer(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            addChild(this._itemContainer);
            this._self.addEventListener(LivingEvent.ENERGY_CHANGED, this.__energyChange);
            this._self.addEventListener(LivingEvent.DIE, this.__die);
            this._self.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__changeAttack);
        }

        public function get itemContainer():ItemContainer
        {
            return (this._itemContainer);
        }

        public function get self():LocalPlayer
        {
            return (this._self);
        }

        public function setClickEnabled(_arg_1:Boolean, _arg_2:Boolean):void
        {
            this._itemContainer.setState(_arg_1, _arg_2);
        }

        public function dispose():void
        {
            this._self.removeEventListener(LivingEvent.DIE, this.__die);
            this._self.removeEventListener(LivingEvent.ENERGY_CHANGED, this.__energyChange);
            this._self.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__changeAttack);
            removeChild(this._itemContainer);
            this._itemContainer.removeEventListener(ItemEvent.ITEM_CLICK, this.__click);
            this._itemContainer.removeEventListener(ItemEvent.ITEM_MOVE, this.__move);
            this._itemContainer.removeEventListener(ItemEvent.ITEM_OUT, this.__out);
            this._itemContainer.removeEventListener(ItemEvent.ITEM_OVER, this.__over);
            this._itemContainer.dispose();
            this._itemContainer = null;
            if (parent)
            {
                parent.removeChild(this);
                this._itemContainer = null;
            };
        }

        private function __changeAttack(_arg_1:LivingEvent):void
        {
            if ((((this._self.isAttacking) && (this._self.isLiving)) && (!(this._self.LockState))))
            {
                this.setClickEnabled(false, false);
            };
        }

        private function __die(_arg_1:LivingEvent):void
        {
            this.setClickEnabled(false, false);
        }

        protected function __energyChange(_arg_1:LivingEvent):void
        {
            if (((this._self.isLiving) && (!(this._self.LockState))))
            {
                this._itemContainer.setClickByEnergy(this._self.energy);
            }
            else
            {
                if (((this._self.isLiving) && (this._self.LockState)))
                {
                    this.setClickEnabled(false, true);
                };
            };
        }

        protected function __move(_arg_1:ItemEvent):void
        {
        }

        public function setVisible(_arg_1:int, _arg_2:Boolean):void
        {
            this._itemContainer.setVisible(_arg_1, _arg_2);
        }

        protected function __over(_arg_1:ItemEvent):void
        {
        }

        protected function __out(_arg_1:ItemEvent):void
        {
        }

        protected function __click(_arg_1:ItemEvent):void
        {
        }

        public function setLayerMode(_arg_1:int):void
        {
        }


    }
}//package game.view.propContainer

