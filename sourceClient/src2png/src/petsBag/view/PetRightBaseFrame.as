// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.PetRightBaseFrame

package petsBag.view
{
    import pet.date.PetInfo;

    public class PetRightBaseFrame extends PetBaseFrame 
    {

        protected var _info:PetInfo;


        public function get info():PetInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:PetInfo):void
        {
            this._info = _arg_1;
        }

        public function reset():void
        {
        }

        override public function dispose():void
        {
            this._info = null;
            super.dispose();
        }


    }
}//package petsBag.view

