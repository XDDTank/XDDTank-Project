// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.CustomPropBar

package game.view.prop
{
    import ddt.data.player.SelfInfo;
    import game.model.LocalPlayer;
    import ddt.events.BagEvent;
    import ddt.events.LivingEvent;
    import ddt.events.FightPropEevnt;
    import game.view.control.FightControlBar;
    import org.aswing.KeyboardManager;
    import flash.events.KeyboardEvent;
    import ddt.manager.GameInSocketOut;
    import ddt.manager.SoundManager;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.PropInfo;
    import flash.utils.Dictionary;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import org.aswing.KeyStroke;
    import ddt.data.UsePropErrorCode;
    import ddt.data.EquipType;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.data.BagInfo;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class CustomPropBar extends FightPropBar 
    {

        private var _selfInfo:SelfInfo;
        private var _type:int;
        private var _backStyle:String;
        private var _localVisible:Boolean = true;

        public function CustomPropBar(_arg_1:LocalPlayer, _arg_2:int)
        {
            this._selfInfo = (_arg_1.playerInfo as SelfInfo);
            this._type = _arg_2;
            super(_arg_1);
        }

        override protected function addEvent():void
        {
            var _local_1:PropCell;
            this._selfInfo.FightBag.addEventListener(BagEvent.UPDATE, this.__updateProp);
            _self.addEventListener(LivingEvent.CUSTOMENABLED_CHANGED, this.__customEnabledChanged);
            for each (_local_1 in _cells)
            {
                _local_1.addEventListener(FightPropEevnt.DELETEPROP, this.__deleteProp);
                _local_1.addEventListener(FightPropEevnt.USEPROP, this.__useProp);
            };
            if (this._type == FightControlBar.LIVE)
            {
                _self.addEventListener(LivingEvent.ENERGY_CHANGED, __energyChange);
            };
            _self.addEventListener(LivingEvent.PROPENABLED_CHANGED, this.__enabledChanged);
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
        }

        private function __psychicChanged(_arg_1:LivingEvent):void
        {
            if (_enabled)
            {
                this.updatePropByPsychic();
            };
        }

        private function updatePropByPsychic():void
        {
            var _local_1:PropCell;
            for each (_local_1 in _cells)
            {
                _local_1.enabled = ((!(_local_1.info == null)) && (_self.psychic >= _local_1.info.needPsychic));
            };
        }

        override protected function __enabledChanged(_arg_1:LivingEvent):void
        {
            enabled = (((_self.propEnabled) && (_self.customPropEnabled)) && (!(_self.isBoss)));
        }

        private function __customEnabledChanged(_arg_1:LivingEvent):void
        {
            enabled = ((_self.customPropEnabled) && (!(_self.isBoss)));
        }

        private function __deleteProp(_arg_1:FightPropEevnt):void
        {
            var _local_2:PropCell = (_arg_1.currentTarget as PropCell);
            GameInSocketOut.sendThrowProp(_local_2.info.Place);
            SoundManager.instance.play("008");
            StageReferance.stage.focus = null;
        }

        private function __updateProp(_arg_1:BagEvent):void
        {
            var _local_3:InventoryItemInfo;
            var _local_4:InventoryItemInfo;
            var _local_5:PropInfo;
            var _local_2:Dictionary = _arg_1.changedSlots;
            for each (_local_3 in _local_2)
            {
                _local_4 = this._selfInfo.FightBag.getItemAt(_local_3.Place);
                if (_local_4)
                {
                    _local_5 = new PropInfo(_local_4);
                    _local_5.Place = _local_4.Place;
                    _cells[_local_3.Place].info = _local_5;
                }
                else
                {
                    _cells[_local_3.Place].info = null;
                };
            };
        }

        override protected function removeEvent():void
        {
            var _local_1:PropCell;
            this._selfInfo.FightBag.removeEventListener(BagEvent.UPDATE, this.__updateProp);
            _self.removeEventListener(LivingEvent.CUSTOMENABLED_CHANGED, this.__customEnabledChanged);
            for each (_local_1 in _cells)
            {
                _local_1.removeEventListener(FightPropEevnt.DELETEPROP, this.__deleteProp);
                _local_1.removeEventListener(FightPropEevnt.USEPROP, this.__useProp);
            };
            super.removeEvent();
        }

        override protected function drawCells():void
        {
            var _local_1:Point;
            var _local_2:CustomPropCell = new CustomPropCell("z", _mode, this._type);
            _local_1 = ComponentFactory.Instance.creatCustomObject("CustomPropCellPosz");
            _local_2.setPossiton(_local_1.x, _local_1.y);
            addChild(_local_2);
            var _local_3:CustomPropCell = new CustomPropCell("x", _mode, this._type);
            _local_1 = ComponentFactory.Instance.creatCustomObject("CustomPropCellPosx");
            _local_3.setPossiton(_local_1.x, _local_1.y);
            addChild(_local_3);
            var _local_4:CustomPropCell = new CustomPropCell("c", _mode, this._type);
            _local_1 = ComponentFactory.Instance.creatCustomObject("CustomPropCellPosc");
            _local_4.setPossiton(_local_1.x, _local_1.y);
            addChild(_local_4);
            _cells.push(_local_2);
            _cells.push(_local_3);
            _cells.push(_local_4);
            drawLayer();
        }

        override protected function __keyDown(_arg_1:KeyboardEvent):void
        {
            switch (_arg_1.keyCode)
            {
                case KeyStroke.VK_Z.getCode():
                    _cells[0].useProp();
                    return;
                case KeyStroke.VK_X.getCode():
                    _cells[1].useProp();
                    return;
                case KeyStroke.VK_C.getCode():
                    _cells[2].useProp();
                    return;
            };
        }

        private function __useProp(_arg_1:FightPropEevnt):void
        {
            var _local_2:PropInfo;
            var _local_3:String;
            var _local_4:String;
            if (((_enabled) && (this._localVisible)))
            {
                _local_2 = PropCell(_arg_1.currentTarget).info;
                _local_3 = _self.useProp(_local_2, 2);
                if (_local_3 == UsePropErrorCode.Done)
                {
                    _local_4 = EquipType.hasPropAnimation(_local_2.Template);
                    if (_local_4 != null)
                    {
                        _self.showEffect(_local_4);
                    };
                }
                else
                {
                    if (_local_3 == UsePropErrorCode.SoulNotYourTurn)
                    {
                        PropCell(_arg_1.currentTarget).isUsed = false;
                    }
                    else
                    {
                        if (((!(_local_3 == UsePropErrorCode.Done)) && (!(_local_3 == UsePropErrorCode.None))))
                        {
                            PropCell(_arg_1.currentTarget).isUsed = false;
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation(("tank.game.prop." + _local_3)));
                        };
                    };
                };
            };
            if ((!(_enabled)))
            {
                PropCell(_arg_1.currentTarget).isUsed = false;
            };
        }

        override public function enter():void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:PropInfo;
            super.enter();
            var _local_1:BagInfo = this._selfInfo.FightBag;
            for each (_local_2 in _local_1.items)
            {
                _local_3 = new PropInfo(_local_2);
                _local_3.Place = _local_2.Place;
                _cells[_local_2.Place].info = _local_3;
            };
            enabled = ((_self.customPropEnabled) && (!(_self.isBoss)));
        }

        public function set backStyle(_arg_1:String):void
        {
            var _local_2:DisplayObject;
            if (this._backStyle != _arg_1)
            {
                this._backStyle = _arg_1;
                _local_2 = _background;
                _background = ComponentFactory.Instance.creat(this._backStyle);
                addChildAt(_background, 0);
                ObjectUtils.disposeObject(_local_2);
            };
        }

        public function setVisible(_arg_1:Boolean):void
        {
            if (this._localVisible != _arg_1)
            {
                this._localVisible = _arg_1;
            };
        }


    }
}//package game.view.prop

