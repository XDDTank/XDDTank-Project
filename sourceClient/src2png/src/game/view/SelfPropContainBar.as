// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.SelfPropContainBar

package game.view
{
    import game.view.propContainer.BaseGamePropBarView;
    import flash.display.Bitmap;
    import ddt.data.player.SelfInfo;
    import game.view.propContainer.PropShortCutView;
    import bagAndInfo.bag.ItemCellView;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import game.model.LocalPlayer;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.PropInfo;
    import ddt.data.BagInfo;
    import org.aswing.KeyStroke;
    import flash.events.KeyboardEvent;
    import org.aswing.KeyboardManager;
    import ddt.events.BagEvent;
    import flash.utils.Dictionary;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.view.PropItemView;
    import ddt.manager.GameInSocketOut;
    import flash.events.Event;
    import ddt.events.ItemEvent;

    public class SelfPropContainBar extends BaseGamePropBarView 
    {

        public static var USE_THREE_SKILL:String = "useThreeSkill";
        public static var USE_PLANE:String = "usePlane";

        private var _back:Bitmap;
        private var _info:SelfInfo;
        private var _shortCut:PropShortCutView;
        private var _myitems:Array;

        public function SelfPropContainBar(_arg_1:LocalPlayer)
        {
            super(_arg_1, 3, 3, false, false, false, ItemCellView.PROP_SHORT);
            this._back = ComponentFactory.Instance.creatBitmap("asset.game.propBackAsset");
            addChild(this._back);
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("asset.game.itemContainerPos");
            _itemContainer.x = _local_2.x;
            _itemContainer.y = _local_2.y;
            addChild(_itemContainer);
            this._shortCut = new PropShortCutView();
            this._shortCut.setPropCloseEnabled(0, false);
            this._shortCut.setPropCloseEnabled(1, false);
            this._shortCut.setPropCloseEnabled(2, false);
            addChild(this._shortCut);
            this.setLocalPlayer((_arg_1.playerInfo as SelfInfo));
            this.initData();
        }

        private function initData():void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:PropInfo;
            var _local_1:BagInfo = this._info.FightBag;
            for each (_local_2 in _local_1.items)
            {
                _local_3 = new PropInfo(_local_2);
                _local_3.Place = _local_2.Place;
                this.addProp(_local_3);
            };
        }

        private function __keyDown(_arg_1:KeyboardEvent):void
        {
            switch (_arg_1.keyCode)
            {
                case KeyStroke.VK_Z.getCode():
                    _itemContainer.mouseClickAt(0);
                    return;
                case KeyStroke.VK_X.getCode():
                    _itemContainer.mouseClickAt(1);
                    return;
                case KeyStroke.VK_C.getCode():
                    _itemContainer.mouseClickAt(2);
                    return;
            };
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._shortCut)
            {
                this._shortCut.dispose();
            };
            this._shortCut = null;
            removeChild(this._back);
            this._info = null;
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
        }

        public function setLocalPlayer(_arg_1:SelfInfo):void
        {
            if (this._info != _arg_1)
            {
                if (this._info)
                {
                    this._info.FightBag.removeEventListener(BagEvent.UPDATE, this.__updateProp);
                    _itemContainer.clear();
                };
                this._info = _arg_1;
                if (this._info)
                {
                    this._info.FightBag.addEventListener(BagEvent.UPDATE, this.__updateProp);
                };
            };
        }

        private function __removeProp(_arg_1:BagEvent):void
        {
            var _local_2:PropInfo = new PropInfo((_arg_1.changedSlots as InventoryItemInfo));
            _local_2.Place = _arg_1.changedSlots.Place;
            this.removeProp((_local_2 as PropInfo));
        }

        private function __updateProp(_arg_1:BagEvent):void
        {
            var _local_3:InventoryItemInfo;
            var _local_4:InventoryItemInfo;
            var _local_5:PropInfo;
            var _local_6:PropInfo;
            var _local_2:Dictionary = _arg_1.changedSlots;
            for each (_local_3 in _local_2)
            {
                _local_4 = this._info.FightBag.getItemAt(_local_3.Place);
                if (_local_4)
                {
                    _local_5 = new PropInfo(_local_4);
                    _local_5.Place = _local_4.Place;
                    this.addProp(_local_5);
                }
                else
                {
                    _local_6 = new PropInfo(_local_3);
                    _local_6.Place = _local_3.Place;
                    this.removeProp(_local_6);
                };
            };
        }

        override public function setClickEnabled(_arg_1:Boolean, _arg_2:Boolean):void
        {
            super.setClickEnabled(_arg_1, _arg_2);
        }

        override protected function __click(_arg_1:ItemEvent):void
        {
            var _local_2:PropInfo;
            if (_arg_1.item == null)
            {
                return;
            };
            if (self.LockState)
            {
                if (self.LockType == 0)
                {
                    return;
                };
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.effect.seal"));
            }
            else
            {
                if (((self.isLiving) && (!(self.isAttacking))))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
                    return;
                };
                if (self.energy >= Number(PropItemView(_arg_1.item).info.Template.Property4))
                {
                    _local_2 = PropItemView(_arg_1.item).info;
                    self.useItem(_local_2.Template);
                    GameInSocketOut.sendUseProp(2, _local_2.Place, _local_2.Template.TemplateID);
                    if (_local_2.Template.TemplateID == 10003)
                    {
                        dispatchEvent(new Event(USE_THREE_SKILL));
                    };
                    if (_local_2.Template.TemplateID == 10016)
                    {
                        dispatchEvent(new Event(USE_PLANE));
                    };
                    _itemContainer.setItemClickAt(_local_2.Place, false, true);
                    this._shortCut.setPropCloseVisible(_local_2.Place, false);
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.actions.SelfPlayerWalkAction"));
                };
            };
        }

        override protected function __over(_arg_1:ItemEvent):void
        {
            super.__over(_arg_1);
            this._shortCut.setPropCloseVisible(_arg_1.index, true);
        }

        override protected function __out(_arg_1:ItemEvent):void
        {
            super.__out(_arg_1);
            this._shortCut.setPropCloseVisible(_arg_1.index, false);
        }

        public function addProp(_arg_1:PropInfo):void
        {
            this._shortCut.setPropCloseEnabled(_arg_1.Place, true);
            _itemContainer.appendItemAt(new PropItemView(_arg_1, true, false), _arg_1.Place);
        }

        public function removeProp(_arg_1:PropInfo):void
        {
            this._shortCut.setPropCloseEnabled(_arg_1.Place, false);
            this._shortCut.setPropCloseVisible(_arg_1.Place, false);
            _itemContainer.removeItemAt(_arg_1.Place);
        }


    }
}//package game.view

