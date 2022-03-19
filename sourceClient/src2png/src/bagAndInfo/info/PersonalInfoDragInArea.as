// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.info.PersonalInfoDragInArea

package bagAndInfo.info
{
    import flash.display.Sprite;
    import ddt.interfaces.IAcceptDrag;
    import ddt.data.goods.InventoryItemInfo;
    import bagAndInfo.cell.DragEffect;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.PlayerManager;
    import ddt.manager.ItemManager;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.DragManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SocketManager;
    import ddt.data.BagInfo;

    public class PersonalInfoDragInArea extends Sprite implements IAcceptDrag 
    {

        private var temInfo:InventoryItemInfo;
        private var temEffect:DragEffect;

        public function PersonalInfoDragInArea()
        {
            this.init();
        }

        private function init():void
        {
            graphics.beginFill(0, 0);
            graphics.drawRect(0, 0, 470, 310);
            graphics.endFill();
        }

        public function dragDrop(_arg_1:DragEffect):void
        {
            var _local_4:BaseAlerFrame;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            var _local_3:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_local_2.TemplateID);
            if (_local_3)
            {
                if (_local_2.NeedLevel > PlayerManager.Instance.Self.Grade)
                {
                    DragManager.acceptDrag(this, DragEffect.NONE);
                    return (MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.need")));
                };
            };
            if (((((_local_2.BindType == 1) || (_local_2.BindType == 2)) || (_local_2.BindType == 3)) && (_local_2.IsBinds == false)))
            {
                _local_4 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
                _local_4.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
                this.temInfo = _local_2;
                this.temEffect = _arg_1;
                DragManager.acceptDrag(this, DragEffect.NONE);
                return;
            };
            if (_local_2)
            {
                _arg_1.action = DragEffect.NONE;
                if (_local_2.Place < 31)
                {
                    DragManager.acceptDrag(this);
                }
                else
                {
                    if (PlayerManager.Instance.Self.canEquip(_local_2))
                    {
                        if (PlayerManager.Instance.playerstate == PlayerViewState.FASHION)
                        {
                            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, _local_2.Place, BagInfo.EQUIPBAG, PlayerManager.Instance.getDressEquipPlace(_local_2), _local_2.Count);
                        }
                        else
                        {
                            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, _local_2.Place, BagInfo.EQUIPBAG, PlayerManager.Instance.getEquipPlace(_local_2), _local_2.Count);
                        };
                        DragManager.acceptDrag(this, DragEffect.MOVE);
                    }
                    else
                    {
                        DragManager.acceptDrag(this);
                    };
                };
            };
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = BaseAlerFrame(_arg_1.currentTarget);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.ESC_CLICK:
                    _local_2.dispose();
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.sendDefy();
            };
        }

        private function sendDefy():void
        {
            if (this.temInfo)
            {
                this.temEffect.action = DragEffect.NONE;
                if (this.temInfo.Place < 31)
                {
                    DragManager.acceptDrag(this);
                }
                else
                {
                    if (PlayerManager.Instance.Self.canEquip(this.temInfo))
                    {
                        if (PlayerManager.Instance.playerstate == PlayerViewState.FASHION)
                        {
                            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, this.temInfo.Place, BagInfo.EQUIPBAG, PlayerManager.Instance.getDressEquipPlace(this.temInfo), this.temInfo.Count);
                        }
                        else
                        {
                            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, this.temInfo.Place, BagInfo.EQUIPBAG, PlayerManager.Instance.getEquipPlace(this.temInfo), this.temInfo.Count);
                        };
                        DragManager.acceptDrag(this, DragEffect.MOVE);
                    }
                    else
                    {
                        DragManager.acceptDrag(this);
                    };
                };
            };
        }


    }
}//package bagAndInfo.info

