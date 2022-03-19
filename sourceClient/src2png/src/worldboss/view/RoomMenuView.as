// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.RoomMenuView

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.controls.Frame;
    import ddt.manager.SocketManager;
    import flash.events.Event;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.utils.ObjectUtils;

    public class RoomMenuView extends Sprite implements Disposeable 
    {

        private var _menuIsOpen:Boolean = true;
        private var _BG:Bitmap;
        private var _closeBtn:SimpleBitmapButton;
        private var _switchIMG:ScaleFrameImage;
        private var _returnBtn:SimpleBitmapButton;
        private var _leaveMsg:String;
        private var _alert:BaseAlerFrame;

        public function RoomMenuView()
        {
            this.initialize();
        }

        public function set leaveMsg(_arg_1:String):void
        {
            this._leaveMsg = _arg_1;
        }

        private function initialize():void
        {
            this._BG = ComponentFactory.Instance.creatBitmap("asset.worldBossRoom.menuBG");
            addChild(this._BG);
            this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("asset.worldBossRoom.switchBtn");
            addChild(this._closeBtn);
            this._switchIMG = ComponentFactory.Instance.creatComponentByStylename("asset.worldBossRoom.switchIMG");
            this._switchIMG.setFrame(1);
            this._closeBtn.addChild(this._switchIMG);
            this._returnBtn = ComponentFactory.Instance.creatComponentByStylename("asset.worldBossRoom.returnBtn");
            addChild(this._returnBtn);
            this.setEvent();
        }

        private function setEvent():void
        {
            this._returnBtn.addEventListener(MouseEvent.CLICK, this.backRoomList);
            this._closeBtn.addEventListener(MouseEvent.CLICK, this.switchMenu);
        }

        private function backRoomList(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation(this._leaveMsg), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
            this._alert.addEventListener(FrameEvent.RESPONSE, this.__frameResponse);
        }

        private function __frameResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:Frame = (_arg_1.target as Frame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    SocketManager.Instance.out.sendLeaveBossRoom();
                    SoundManager.instance.play("008");
                    dispatchEvent(new Event(Event.CLOSE));
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    _local_2.dispose();
                    return;
            };
        }

        private function switchMenu(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._menuIsOpen)
            {
                this._switchIMG.setFrame(2);
            }
            else
            {
                this._switchIMG.setFrame(1);
            };
            addEventListener(Event.ENTER_FRAME, this.menuShowOrHide);
        }

        private function menuShowOrHide(_arg_1:Event):void
        {
            var _local_2:int;
            _local_2 = 34;
            if (this._menuIsOpen)
            {
                this.x = (this.x + 20);
                if (this.x >= (StageReferance.stageWidth - _local_2))
                {
                    removeEventListener(Event.ENTER_FRAME, this.menuShowOrHide);
                    this.x = (StageReferance.stageWidth - _local_2);
                    this._menuIsOpen = false;
                };
            }
            else
            {
                this.x = (this.x - 20);
                if (this.x <= (StageReferance.stageWidth - this.width))
                {
                    removeEventListener(Event.ENTER_FRAME, this.menuShowOrHide);
                    this.x = ((StageReferance.stageWidth - this.width) + 5);
                    this._menuIsOpen = true;
                };
            };
        }

        public function dispose():void
        {
            var _local_1:Object;
            ObjectUtils.disposeObject(this._BG);
            this._BG = null;
            ObjectUtils.disposeObject(this._closeBtn);
            this._closeBtn = null;
            ObjectUtils.disposeObject(this._switchIMG);
            this._switchIMG = null;
            ObjectUtils.disposeObject(this._returnBtn);
            this._returnBtn = null;
            ObjectUtils.disposeObject(this._alert);
            this._alert = null;
            while (numChildren > 0)
            {
                _local_1 = getChildAt(0);
                ObjectUtils.disposeObject(_local_1);
                _local_1 = null;
            };
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package worldboss.view

