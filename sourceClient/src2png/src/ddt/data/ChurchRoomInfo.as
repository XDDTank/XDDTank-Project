// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.ChurchRoomInfo

package ddt.data
{
    import flash.events.EventDispatcher;
    import church.events.WeddingRoomEvent;

    public class ChurchRoomInfo extends EventDispatcher 
    {

        public static const WEDDING_NONE:String = "wedding_none";
        public static const WEDDING_ING:String = "wedding_ing";

        public var id:int;
        public var roomName:String = "";
        public var brideID:int;
        public var brideName:String;
        public var groomID:int;
        public var groomName:String;
        public var createID:int;
        public var createName:String;
        public var mapID:int;
        public var isLocked:Boolean;
        public var password:String = "";
        public var discription:String = "";
        public var canInvite:Boolean;
        public var isUsedSalute:Boolean;
        public var creactTime:Date;
        private var _validTimes:uint;
        public var maxNum:uint = 200;
        private var _status:String = "wedding_none";
        private var _currentNum:uint;
        private var _isStarted:Boolean;


        public function get isStarted():Boolean
        {
            return (this._isStarted);
        }

        public function set isStarted(_arg_1:Boolean):void
        {
            this._isStarted = _arg_1;
        }

        public function get valideTimes():uint
        {
            return (this._validTimes);
        }

        public function set valideTimes(_arg_1:uint):void
        {
            this._validTimes = _arg_1;
            dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.ROOM_VALIDETIME_CHANGE, this));
        }

        public function get currentNum():uint
        {
            return (this._currentNum);
        }

        public function set currentNum(_arg_1:uint):void
        {
            this._currentNum = _arg_1;
        }

        public function get status():String
        {
            return (this._status);
        }

        public function set status(_arg_1:String):void
        {
            if (this._status == _arg_1)
            {
                return;
            };
            this._status = _arg_1;
            dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.WEDDING_STATUS_CHANGE, this));
        }


    }
}//package ddt.data

