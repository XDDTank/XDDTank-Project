// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.TimerOpenManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.events.TimeEvents;
    import ddt.events.BagEvent;
    import ddt.data.EquipType;
    import road7th.utils.DateUtils;
    import game.view.GetGoodsTipView;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.MainToolBar;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import com.pickgliss.action.FunctionAction;
    import com.pickgliss.utils.ObjectUtils;
    import bagAndInfo.BagAndInfoManager;
    import __AS3__.vec.*;

    public class TimerOpenManager extends EventDispatcher 
    {

        private static var _instance:TimerOpenManager;

        private var _checkList:Vector.<InventoryItemInfo>;
        private var _info:InventoryItemInfo;
        private var _Open:Boolean = true;


        public static function get Instance():TimerOpenManager
        {
            if (_instance == null)
            {
                _instance = new (TimerOpenManager)();
            };
            return (_instance);
        }


        public function setup():void
        {
            this._checkList = new Vector.<InventoryItemInfo>();
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__timerTick);
            PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE, this.__bagUpdate);
        }

        private function __timerTick(_arg_1:TimeEvents):void
        {
            var _local_2:int;
            var _local_3:Date;
            var _local_4:int;
            if (this._checkList.length > 0)
            {
                _local_2 = 0;
                while (_local_2 < this._checkList.length)
                {
                    if (EquipType.isPetsEgg(this._checkList[_local_2]))
                    {
                        _local_3 = DateUtils.getDateByStr(this._checkList[_local_2].BeginDate);
                        _local_4 = int(((int(this._checkList[_local_2].Property3) * 60) - ((TimeManager.Instance.Now().getTime() - _local_3.getTime()) / 1000)));
                        if (_local_4 <= 0)
                        {
                            this._info = this._checkList[_local_2];
                            this.show();
                            this._checkList.splice(_local_2, 1);
                        };
                    };
                    _local_2++;
                };
            };
        }

        public function firstLogin():void
        {
            var _local_1:InventoryItemInfo;
            var _local_2:Date;
            var _local_3:int;
            for each (_local_1 in PlayerManager.Instance.Self.Bag.items)
            {
                if (EquipType.isTimeBox(_local_1))
                {
                    _local_2 = DateUtils.getDateByStr((_local_1 as InventoryItemInfo).BeginDate);
                    _local_3 = int(((int(_local_1.Property3) * 60) - ((TimeManager.Instance.Now().getTime() - _local_2.getTime()) / 1000)));
                    if (_local_3 <= 0)
                    {
                        this._checkList.push(_local_1);
                    };
                };
            };
            this.__timerTick(null);
        }

        private function __bagUpdate(_arg_1:BagEvent):void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:Boolean;
            var _local_4:InventoryItemInfo;
            var _local_5:Date;
            var _local_6:int;
            for each (_local_2 in _arg_1.changedSlots)
            {
                _local_3 = false;
                for each (_local_4 in this._checkList)
                {
                    if (_local_4.ItemID == _local_2.ItemID)
                    {
                        _local_3 = true;
                        break;
                    };
                };
                if (((!(_local_3)) && (EquipType.isTimeBox(_local_2))))
                {
                    _local_5 = DateUtils.getDateByStr((_local_2 as InventoryItemInfo).BeginDate);
                    _local_6 = int(((int(_local_2.Property3) * 60) - ((TimeManager.Instance.Now().getTime() - _local_5.getTime()) / 1000)));
                    if (_local_6 > 0)
                    {
                        this._checkList.push(_local_2);
                    };
                };
            };
        }

        public function show():void
        {
            var _alert:GetGoodsTipView;
            var showFunc:Function;
            if (((this._info) && (this._Open)))
            {
                _alert = ComponentFactory.Instance.creatComponentByStylename("trainer.view.GetGoodsTip");
                _alert.item = this._info;
                _alert.addEventListener(FrameEvent.RESPONSE, this.__alertResponse);
                showFunc = function ():void
                {
                    LayerManager.Instance.addToLayer(_alert, LayerManager.GAME_DYNAMIC_LAYER, false, 0, false);
                    LayerManager.Instance.getLayerByType(LayerManager.GAME_DYNAMIC_LAYER).setChildIndex(_alert, 0);
                };
                if ((!(MainToolBar.Instance.canOpenBag())))
                {
                    CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_FIGHT, new FunctionAction(showFunc));
                }
                else
                {
                    (showFunc());
                };
            };
        }

        private function __alertResponse(_arg_1:FrameEvent):void
        {
            var _local_3:InventoryItemInfo;
            var _local_4:Array;
            SoundManager.instance.play("008");
            var _local_2:GetGoodsTipView = (_arg_1.target as GetGoodsTipView);
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                _local_4 = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(_local_2.item.TemplateID);
                _local_3 = _local_4[0];
                _local_2.removeEventListener(FrameEvent.RESPONSE, this.__alertResponse);
                ObjectUtils.disposeObject(_local_2);
                _local_2 = null;
                PlayerManager.Instance.Self.EquipInfo = _local_3;
                BagAndInfoManager.Instance.showBagAndInfo();
                this._Open = false;
            }
            else
            {
                _local_2.removeEventListener(FrameEvent.RESPONSE, this.__alertResponse);
                ObjectUtils.disposeObject(_local_2);
                _local_2 = null;
                this._Open = false;
            };
        }


    }
}//package ddt.manager

