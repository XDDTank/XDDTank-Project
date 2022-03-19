// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//turnplate.TurnPlateController

package turnplate
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import flash.events.Event;
    import road7th.comm.PackageIn;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.manager.ServerManager;
    import ddt.manager.PlayerManager;
    import flash.utils.setTimeout;
    import ddt.manager.MessageTipManager;
    import ddt.data.EquipType;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class TurnPlateController extends EventDispatcher 
    {

        private static var _instance:TurnPlateController;
        public static const TURNPLATE_HISTORY:uint = 3;
        public static const STATE_CHANGE:String = "state_change";

        private const MAX_MESSAGE:uint = 20;

        private var _historyList:Vector.<FilterFrameText>;
        private var _view:TurnPlateFrame;
        private var _isFrameOpen:Boolean;
        private var _isOpen:Boolean;

        public function TurnPlateController()
        {
            this._historyList = new Vector.<FilterFrameText>();
        }

        public static function get Instance():TurnPlateController
        {
            if ((!(_instance)))
            {
                _instance = new (TurnPlateController)();
            };
            return (_instance);
        }


        public function setup():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TURNPLATE_HISTORY_MESSAGE, this.__getRewardMessage);
        }

        public function openStatus(_arg_1:PackageIn):void
        {
            this._isOpen = _arg_1.readBoolean();
            dispatchEvent(new Event(STATE_CHANGE));
        }

        private function __getRewardMessage(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:String;
            var _local_6:String;
            var _local_7:int;
            var _local_8:InventoryItemInfo;
            var _local_9:FilterFrameText;
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readInt();
            var _local_4:uint;
            while (_local_4 < _local_3)
            {
                _local_5 = _local_2.readUTF();
                _local_6 = _local_2.readUTF();
                _local_7 = _local_2.readInt();
                _local_8 = new InventoryItemInfo();
                _local_8.TemplateID = _local_7;
                ItemManager.fill(_local_8);
                _local_9 = ComponentFactory.Instance.creatComponentByStylename("turnplate.historyTxt");
                _local_9.htmlText = LanguageMgr.GetTranslation("ddt.turnplate.historyMessage.txt", _local_5, _local_6, _local_8.Name);
                if (this._historyList.length >= this.MAX_MESSAGE)
                {
                    this._historyList.shift();
                };
                if ((((_local_6 == PlayerManager.Instance.Self.NickName) && (ServerManager.Instance.zoneName == _local_5)) && (!(this._isFrameOpen))))
                {
                    setTimeout(this.showDelayMessage, 8000, _local_9);
                }
                else
                {
                    this._historyList.push(_local_9);
                };
                _local_4++;
            };
            if (this._historyList.length > 0)
            {
                if (this._view)
                {
                    this._view.addHistoryMessage(this._historyList);
                };
            };
            if (this._isFrameOpen)
            {
                this._isFrameOpen = false;
            };
        }

        public function showDelayMessage(_arg_1:FilterFrameText):void
        {
            this._historyList.push(_arg_1);
            if (this._view)
            {
                this._view.addHistoryMessage(this._historyList);
            };
        }

        public function show():void
        {
            if ((!(this._isOpen)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.turnplate.notOpen.txt"));
                return;
            };
            this._view = ComponentFactory.Instance.creatCustomObject("turnplate.turnplateFrame");
            this._view.show();
        }

        public function hide():void
        {
            this._view.dispose();
            this._view = null;
        }

        public function getBoguCoinCount():int
        {
            var _local_3:InventoryItemInfo;
            var _local_1:Array = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(EquipType.BOGU_COIN);
            var _local_2:int;
            for each (_local_3 in _local_1)
            {
                _local_2 = (_local_2 + _local_3.Count);
            };
            return (_local_2);
        }

        public function get historyList():Vector.<FilterFrameText>
        {
            return (this._historyList);
        }

        public function clearHistoryList():void
        {
            var _local_1:FilterFrameText;
            for each (_local_1 in this._historyList)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = null;
            };
            this._historyList = new Vector.<FilterFrameText>();
        }

        public function forcibleClose():void
        {
            if (this._view)
            {
                this._view.forcibleClose();
            };
        }

        public function set isFrameOpen(_arg_1:Boolean):void
        {
            this._isFrameOpen = _arg_1;
        }

        public function get isShow():Boolean
        {
            if (this._view)
            {
                return (true);
            };
            return (false);
        }

        public function get isOpen():Boolean
        {
            return (this._isOpen);
        }


    }
}//package turnplate

