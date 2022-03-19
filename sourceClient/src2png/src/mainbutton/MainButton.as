// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//mainbutton.MainButton

package mainbutton
{
    public class MainButton 
    {

        public var ID:String;
        private var _btnMark:int;
        private var _btnName:String;
        private var _btnServerVisable:int;
        private var _btnCompleteVisable:int;
        public var IsShow:Boolean;


        public function get btnCompleteVisable():int
        {
            return (this._btnCompleteVisable);
        }

        public function set btnCompleteVisable(_arg_1:int):void
        {
            this._btnCompleteVisable = _arg_1;
        }

        public function get btnServerVisable():int
        {
            return (this._btnServerVisable);
        }

        public function set btnServerVisable(_arg_1:int):void
        {
            this._btnServerVisable = _arg_1;
        }

        public function get btnName():String
        {
            return (this._btnName);
        }

        public function set btnName(_arg_1:String):void
        {
            this._btnName = _arg_1;
        }

        public function get btnMark():int
        {
            return (this._btnMark);
        }

        public function set btnMark(_arg_1:int):void
        {
            this._btnMark = _arg_1;
        }


    }
}//package mainbutton

