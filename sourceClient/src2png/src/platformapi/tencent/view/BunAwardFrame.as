// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.BunAwardFrame

package platformapi.tencent.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.MutipleImage;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import ddt.manager.PlayerManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import ddt.data.DailyAwardType;
    import com.pickgliss.utils.ObjectUtils;

    public class BunAwardFrame extends Frame implements Disposeable 
    {

        private var _titlebg:Bitmap;
        private var _bg:MutipleImage;
        private var _decribe:MovieClip;
        private var _getBtn:SimpleBitmapButton;
        private var _vbox:VBox;
        private var _itmes:Array;

        public function BunAwardFrame()
        {
            this.initEvent();
        }

        override protected function init():void
        {
            super.init();
            this._titlebg = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.bun.title");
            addToContent(this._titlebg);
            this._bg = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.BunAwardFrame.bg");
            addToContent(this._bg);
            this._decribe = ClassUtils.CreatInstance("asset.MemberDiamondGift.bun.describe");
            PositionUtils.setPos(this._decribe, "asset.MemberDiamondGift.bun.describePos");
            addToContent(this._decribe);
            this._vbox = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.BunAwardFrame.vbox");
            addToContent(this._vbox);
            this.createItem();
            this._getBtn = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.BunAwardFrame.getBtn");
            this._getBtn.enable = PlayerManager.Instance.Self.canTakeLevel3366Pack;
            addToContent(this._getBtn);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this._frameResponse);
            this._getBtn.addEventListener(MouseEvent.CLICK, this._getBtnClick);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this._frameResponse);
            this._getBtn.removeEventListener(MouseEvent.CLICK, this._getBtnClick);
        }

        private function createItem():void
        {
            var _local_2:BunAwardItem;
            this._itmes = [];
            var _local_1:int;
            while (_local_1 < 6)
            {
                _local_2 = new BunAwardItem((_local_1 + 1));
                this._vbox.addChild(_local_2);
                this._itmes.push(_local_2);
                _local_1++;
            };
        }

        private function clearItem():void
        {
            var _local_1:int;
            while (_local_1 < 6)
            {
                this._itmes[_local_1].dispose();
                this._itmes[_local_1] = null;
                _local_1++;
            };
        }

        private function _getBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendDiamondAward(DailyAwardType.BunAward);
            this._getBtn.visible = (PlayerManager.Instance.Self.canTakeLevel3366Pack = false);
            this.dispose();
        }

        private function _frameResponse(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    SoundManager.instance.play("008");
                    this.dispose();
                    return;
            };
        }

        override public function dispose():void
        {
            super.dispose();
            this.clearItem();
            ObjectUtils.disposeObject(this._titlebg);
            this._titlebg = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._decribe);
            this._decribe = null;
            ObjectUtils.disposeObject(this._getBtn);
            this._getBtn = null;
            ObjectUtils.disposeObject(this._vbox);
            this._vbox = null;
            ObjectUtils.disposeObject(this._itmes);
            this._vbox = null;
        }


    }
}//package platformapi.tencent.view

