// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.invite.ChurchInviteModel

package church.view.invite
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.Event;

    public class ChurchInviteModel extends EventDispatcher 
    {

        public static const LIST_UPDATE:String = "listupdate";

        private var _type:int;
        private var _currentList:Array;

        public function ChurchInviteModel(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
        }

        public function setList(_arg_1:int, _arg_2:Array):void
        {
            this._type = _arg_1;
            this._currentList = _arg_2;
            dispatchEvent(new Event(LIST_UPDATE));
        }

        public function get currentList():Array
        {
            return (this._currentList);
        }

        public function get type():int
        {
            return (this._type);
        }

        public function dispose():void
        {
        }


    }
}//package church.view.invite

