// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.view.HonorUpFrame

package totem.view
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import totem.HonorUpManager;
    import totem.data.HonorUpDataVo;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.LeavePageManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;

    public class HonorUpFrame extends Frame 
    {

        private var _bg:Bitmap;
        private var _btnBg:Scale9CornerImage;
        private var _tip1:FilterFrameText;
        private var _tip2:FilterFrameText;
        private var _tip3:FilterFrameText;
        private var _upBtn:SimpleBitmapButton;

        public function HonorUpFrame()
        {
            this.initView();
            this.initEvent();
            this.refreshShow(null);
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("ddt.totem.honorUpFrame.titleTxt");
            this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.honorUpFrame.mainBg");
            this._btnBg = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpFrame.btnBg");
            this._tip1 = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpFrame.tip1");
            this._tip2 = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpFrame.tip2");
            this._tip3 = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpFrame.tip3");
            this._upBtn = ComponentFactory.Instance.creatComponentByStylename("totem.honorUpFrame.upBtn");
            addToContent(this._bg);
            addToContent(this._btnBg);
            addToContent(this._tip1);
            addToContent(this._tip2);
            addToContent(this._tip3);
            addToContent(this._upBtn);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._upBtn.addEventListener(MouseEvent.CLICK, this.doUpHonor, false, 0, true);
            HonorUpManager.instance.addEventListener(HonorUpManager.UP_COUNT_UPDATE, this.refreshShow, false, 0, true);
        }

        private function refreshShow(_arg_1:Event):void
        {
            var _local_4:HonorUpDataVo;
            var _local_2:Array = HonorUpManager.instance.dataList;
            var _local_3:int = HonorUpManager.instance.upCount;
            if (_local_3 >= _local_2.length)
            {
                this.dispose();
            }
            else
            {
                _local_4 = (_local_2[_local_3] as HonorUpDataVo);
                this._tip1.text = LanguageMgr.GetTranslation("ddt.totem.honorUpFrame.tip1");
                this._tip2.text = _local_4.honor.toString();
                this._tip3.text = _local_4.money.toString();
            };
        }

        private function doUpHonor(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:Array = HonorUpManager.instance.dataList;
            var _local_3:int = HonorUpManager.instance.upCount;
            if (PlayerManager.Instance.Self.totalMoney < (_local_2[_local_3] as HonorUpDataVo).money)
            {
                LeavePageManager.showFillFrame();
                return;
            };
            SocketManager.Instance.out.sendHonorUp(2);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                dispatchEvent(new Event(Event.CLOSE));
                this.dispose();
            };
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._upBtn.removeEventListener(MouseEvent.CLICK, this.doUpHonor);
            HonorUpManager.instance.removeEventListener(HonorUpManager.UP_COUNT_UPDATE, this.refreshShow);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._btnBg);
            this._btnBg = null;
            ObjectUtils.disposeObject(this._tip1);
            this._tip1 = null;
            ObjectUtils.disposeObject(this._tip2);
            this._tip2 = null;
            ObjectUtils.disposeObject(this._tip3);
            this._tip3 = null;
            ObjectUtils.disposeObject(this._upBtn);
            this._upBtn = null;
            super.dispose();
        }


    }
}//package totem.view

