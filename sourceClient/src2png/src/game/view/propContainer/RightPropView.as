// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.propContainer.RightPropView

package game.view.propContainer
{
    import bagAndInfo.bag.ItemCellView;
    import game.model.LocalPlayer;
    import org.aswing.KeyStroke;
    import flash.events.KeyboardEvent;
    import ddt.data.PropInfo;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.PlayerManager;
    import ddt.data.EquipType;
    import ddt.manager.SharedManager;
    import ddt.manager.ItemManager;
    import ddt.data.BuffInfo;
    import ddt.view.PropItemView;
    import org.aswing.KeyboardManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.GameInSocketOut;
    import ddt.manager.SoundManager;
    import ddt.events.ItemEvent;
    import ddt.manager.ShopManager;
    import ddt.manager.SocketManager;

    public class RightPropView extends BaseGamePropBarView 
    {

        private static const PROP_ID:int = 10;

        public function RightPropView(_arg_1:LocalPlayer)
        {
            super(_arg_1, 8, 1, false, false, false, ItemCellView.RIGHT_PROP);
            this.initView();
            this.setItem();
        }

        private function initView():void
        {
            _itemContainer.vSpace = 4;
        }

        private function __keyDown(_arg_1:KeyboardEvent):void
        {
            switch (_arg_1.keyCode)
            {
                case KeyStroke.VK_1.getCode():
                case KeyStroke.VK_NUMPAD_1.getCode():
                    _itemContainer.mouseClickAt(0);
                    return;
                case KeyStroke.VK_2.getCode():
                case KeyStroke.VK_NUMPAD_2.getCode():
                    _itemContainer.mouseClickAt(1);
                    return;
                case KeyStroke.VK_3.getCode():
                case KeyStroke.VK_NUMPAD_3.getCode():
                    _itemContainer.mouseClickAt(2);
                    return;
                case KeyStroke.VK_4.getCode():
                case KeyStroke.VK_NUMPAD_4.getCode():
                    _itemContainer.mouseClickAt(3);
                    return;
                case KeyStroke.VK_5.getCode():
                case KeyStroke.VK_NUMPAD_5.getCode():
                    _itemContainer.mouseClickAt(4);
                    return;
                case KeyStroke.VK_6.getCode():
                case KeyStroke.VK_NUMPAD_6.getCode():
                    _itemContainer.mouseClickAt(5);
                    return;
                case KeyStroke.VK_7.getCode():
                case KeyStroke.VK_NUMPAD_7.getCode():
                    _itemContainer.mouseClickAt(6);
                    return;
                case KeyStroke.VK_8.getCode():
                case KeyStroke.VK_NUMPAD_8.getCode():
                    _itemContainer.mouseClickAt(7);
                    return;
            };
        }

        public function setItem():void
        {
            var _local_4:String;
            var _local_5:PropInfo;
            var _local_6:Array;
            var _local_7:InventoryItemInfo;
            _itemContainer.clear();
            var _local_1:Boolean;
            var _local_2:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.T_ALL_PROP, true, true);
            var _local_3:Object = SharedManager.Instance.GameKeySets;
            for (_local_4 in _local_3)
            {
                if (int(_local_4) == 9) break;
                _local_5 = new PropInfo(ItemManager.Instance.getTemplateById(_local_3[_local_4]));
                if (((_local_2) || (PlayerManager.Instance.Self.hasBuff(BuffInfo.FREE))))
                {
                    if (_local_2)
                    {
                        _local_5.Place = _local_2.Place;
                    }
                    else
                    {
                        _local_5.Place = -1;
                    };
                    _local_5.Count = -1;
                    _itemContainer.appendItemAt(new PropItemView(_local_5, true, false, -1), (int(_local_4) - 1));
                    _local_1 = true;
                }
                else
                {
                    _local_6 = PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(_local_3[_local_4]);
                    if (_local_6.length > 0)
                    {
                        _local_5.Place = _local_6[0].Place;
                        for each (_local_7 in _local_6)
                        {
                            _local_5.Count = (_local_5.Count + _local_7.Count);
                        };
                        _itemContainer.appendItemAt(new PropItemView(_local_5, true, false), (int(_local_4) - 1));
                        _local_1 = true;
                    }
                    else
                    {
                        _itemContainer.appendItemAt(new PropItemView(_local_5, false, false), (int(_local_4) - 1));
                    };
                };
            };
            if (_local_1)
            {
                _itemContainer.setClickByEnergy(self.energy);
            };
        }

        override public function dispose():void
        {
            super.dispose();
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
        }

        override protected function __click(_arg_1:ItemEvent):void
        {
            var _local_2:PropItemView = (_arg_1.item as PropItemView);
            var _local_3:PropInfo = _local_2.info;
            if (_local_2.isExist)
            {
                if (self.isLiving == false)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.RightPropView.prop"));
                    return;
                };
                if ((!(self.isAttacking)))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
                    return;
                };
                if (self.LockState)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.cantUseItem"));
                    return;
                };
                if (self.energy < _local_3.needEnergy)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.actions.SelfPlayerWalkAction"));
                    return;
                };
                self.useItem(_local_3.Template);
                GameInSocketOut.sendUseProp(0, _local_3.Place, _local_3.Template.TemplateID);
            }
            else
            {
                SoundManager.instance.play("008");
            };
        }

        private function confirm():void
        {
            if (PlayerManager.Instance.Self.Money >= ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.FREE_PROP_CARD).getItemPrice(1).moneyValue)
            {
                SocketManager.Instance.out.sendUseCard(-1, -1, [EquipType.FREE_PROP_CARD], 1, true);
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.stipple"));
            };
        }


    }
}//package game.view.propContainer

