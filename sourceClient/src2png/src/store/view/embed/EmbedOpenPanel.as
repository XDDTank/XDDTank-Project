// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.embed.EmbedOpenPanel

package store.view.embed
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.data.goods.InventoryItemInfo;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.data.EquipType;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import ddt.command.QuickBuyFrame;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;

    public class EmbedOpenPanel extends Sprite implements Disposeable 
    {

        private var _openBtn:BaseButton;
        private var _alert:BaseAlerFrame;
        private var _info:InventoryItemInfo;
        private var _index:int;

        public function EmbedOpenPanel()
        {
            this.init();
            this.addEvent();
        }

        private function init():void
        {
            this._openBtn = ComponentFactory.Instance.creat("ddtstore.embed.embedBg.openPanel.openBtn");
            addChild(this._openBtn);
        }

        protected function addEvent():void
        {
            this._openBtn.addEventListener(MouseEvent.CLICK, this.__click);
        }

        protected function removeEvent():void
        {
            this._openBtn.removeEventListener(MouseEvent.CLICK, this.__click);
            if (this._alert)
            {
                this._alert.removeEventListener(FrameEvent.RESPONSE, this.__response);
            };
        }

        protected function __click(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:Array = EquipType.getEmbedHoleInfo(this._info, this._index);
            if (this._alert)
            {
                this._alert.removeEventListener(FrameEvent.RESPONSE, this.__response);
                this._alert.dispose();
            };
            this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ddt.store.embedBG.openEmbed.alert.msg", _local_2[1], _local_2[2]), LanguageMgr.GetTranslation("yes"), LanguageMgr.GetTranslation("no"), false, true, true);
            this._alert.addEventListener(FrameEvent.RESPONSE, this.__response);
        }

        protected function __response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._alert.removeEventListener(FrameEvent.RESPONSE, this.__response);
            this._alert.dispose();
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.checkDrill();
                    return;
            };
        }

        private function checkDrill():void
        {
            var _local_3:QuickBuyFrame;
            var _local_1:Array = EquipType.getEmbedHoleInfo(this._info, this._index);
            var _local_2:int = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(EquipType.DIAMOND_DRIL);
            if (_local_2 < _local_1[1])
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.lessmsg"));
                _local_3 = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                _local_3.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                _local_3.itemID = EquipType.DIAMOND_DRIL;
                _local_3.stoneNumber = (_local_1[1] - _local_2);
                LayerManager.Instance.addToLayer(_local_3, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            }
            else
            {
                SocketManager.Instance.out.sendOpenEmbedHole(this.index);
            };
        }

        public function get info():InventoryItemInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:InventoryItemInfo):void
        {
            this._info = _arg_1;
        }

        public function get index():int
        {
            return (this._index);
        }

        public function set index(_arg_1:int):void
        {
            this._index = _arg_1;
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._openBtn);
            this._openBtn = null;
            ObjectUtils.disposeObject(this._alert);
            this._alert = null;
            this._info = null;
        }


    }
}//package store.view.embed

