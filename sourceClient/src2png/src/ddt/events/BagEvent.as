// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.BagEvent

package ddt.events
{
    import flash.events.Event;
    import flash.utils.Dictionary;

    public class BagEvent extends Event 
    {

        public static const UPDATE:String = "update";
        public static const PSDPRO:String = "password protection";
        public static const BACK_STEP:String = "backStep";
        public static const CHANGEPSW:String = "changePassword";
        public static const DELPSW:String = "deletePassword";
        public static const AFTERDEL:String = "afterDel";
        public static const NEEDPRO:String = "needprotection";
        public static const UPDATE_SUCCESS:String = "updateSuccess";
        public static const CLEAR:String = "clearSuccess";
        public static const PSW_CLOSE:String = "passwordClose";
        public static const SHOW_BEAD:String = "showBead";
        public static const UPDATE_BAG_CELL:String = "updatebagcell";
        public static const WEAPON_READY:String = "weaponReady";
        public static const WEAPON_REMOVE:String = "weaponRemove";
        public static const FASHION_READY:String = "fashionReady";
        public static const FASHION_REMOVE:String = "fashionRemove";

        private var _flag:Boolean;
        private var _needSecond:Boolean;
        private var _changedSlot:Dictionary;
        private var _passwordArray:Array;

        public function BagEvent(_arg_1:String, _arg_2:Dictionary)
        {
            this._changedSlot = _arg_2;
            super(_arg_1);
        }

        public function get changedSlots():Dictionary
        {
            return (this._changedSlot);
        }

        public function get passwordArray():Array
        {
            return (this._passwordArray);
        }

        public function set passwordArray(_arg_1:Array):void
        {
            this._passwordArray = _arg_1;
        }

        public function get flag():Boolean
        {
            return (this._flag);
        }

        public function set flag(_arg_1:Boolean):void
        {
            this._flag = _arg_1;
        }

        public function get needSecond():Boolean
        {
            return (this._needSecond);
        }

        public function set needSecond(_arg_1:Boolean):void
        {
            this._needSecond = _arg_1;
        }


    }
}//package ddt.events

