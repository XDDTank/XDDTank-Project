// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.model.PlayerAdditionInfo

package game.model
{
    public class PlayerAdditionInfo 
    {

        private var _auncherExperienceAddition:Number = 1;
        private var _gmExperienceAdditionType:Number = 1;
        private var _gmOfferAddition:Number = 1;
        private var _auncherOfferAddition:Number = 1;
        private var _gmRichesAddition:Number = 1;
        private var _auncherRichesAddition:Number = 1;


        public function get AuncherExperienceAddition():Number
        {
            return (this._auncherExperienceAddition);
        }

        public function set AuncherExperienceAddition(_arg_1:Number):void
        {
            this._auncherExperienceAddition = _arg_1;
        }

        public function get GMExperienceAdditionType():Number
        {
            return (this._gmExperienceAdditionType);
        }

        public function set GMExperienceAdditionType(_arg_1:Number):void
        {
            this._gmExperienceAdditionType = _arg_1;
        }

        public function get GMOfferAddition():Number
        {
            return (this._gmOfferAddition);
        }

        public function set GMOfferAddition(_arg_1:Number):void
        {
            this._gmOfferAddition = _arg_1;
        }

        public function get AuncherOfferAddition():Number
        {
            return (this._auncherOfferAddition);
        }

        public function set AuncherOfferAddition(_arg_1:Number):void
        {
            this._auncherOfferAddition = _arg_1;
        }

        public function get GMRichesAddition():Number
        {
            return (this._gmRichesAddition);
        }

        public function set GMRichesAddition(_arg_1:Number):void
        {
            this._gmRichesAddition = _arg_1;
        }

        public function get AuncherRichesAddition():Number
        {
            return (this._auncherRichesAddition);
        }

        public function set AuncherRichesAddition(_arg_1:Number):void
        {
            this._auncherRichesAddition = _arg_1;
        }

        public function resetAddition():void
        {
            this._auncherExperienceAddition = 1;
            this._gmExperienceAdditionType = 1;
            this._gmOfferAddition = 1;
            this._auncherOfferAddition = 1;
            this._gmRichesAddition = 1;
            this._auncherRichesAddition = 1;
        }


    }
}//package game.model

