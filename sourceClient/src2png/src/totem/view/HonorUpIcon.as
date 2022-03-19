// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.view.HonorUpIcon

package totem.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import totem.HonorUpManager;
    import ddt.manager.SocketManager;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class HonorUpIcon extends Sprite implements Disposeable 
    {

        private var _iconBtn:TextButton;
        private var _countTxt:FilterFrameText;

        public function HonorUpIcon()
        {
            this.mouseEnabled = false;
            this._iconBtn = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpIcon.btn");
            this._iconBtn.text = LanguageMgr.GetTranslation("store.Strength.BuyButtonText");
            this._iconBtn.addEventListener(MouseEvent.CLICK, this.openHonorUpFrame, false, 0, true);
            this._iconBtn.enable = false;
            this._countTxt = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpIcon.countTxt");
            addChild(this._iconBtn);
            addChild(this._countTxt);
            HonorUpManager.instance.addEventListener(HonorUpManager.UP_COUNT_UPDATE, this.refreshShow, false, 0, true);
            if (HonorUpManager.instance.upCount >= 0)
            {
                this.refreshShow(null);
            }
            else
            {
                SocketManager.Instance.out.sendHonorUp(1);
            };
        }

        private function refreshShow(_arg_1:Event):void
        {
            this._iconBtn.enable = true;
            this._countTxt.text = (HonorUpManager.instance.dataList.length - HonorUpManager.instance.upCount).toString();
        }

        private function openHonorUpFrame(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (HonorUpManager.instance.upCount >= HonorUpManager.instance.dataList.length)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.totem.honorUp.cannot"));
                return;
            };
            var _local_2:HonorUpFrame = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpFrame");
            _local_2.addEventListener(Event.CLOSE, this.__frameClose);
            LayerManager.Instance.addToLayer(_local_2, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __frameClose(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(Event.CLOSE, this.__frameClose);
            dispatchEvent(_arg_1);
        }

        public function dispose():void
        {
            this._iconBtn.removeEventListener(MouseEvent.CLICK, this.openHonorUpFrame);
            HonorUpManager.instance.removeEventListener(HonorUpManager.UP_COUNT_UPDATE, this.refreshShow);
            ObjectUtils.disposeAllChildren(this);
            this._iconBtn = null;
            this._countTxt = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package totem.view

