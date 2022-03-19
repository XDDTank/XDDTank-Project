// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.view.CDView

package SingleDungeon.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.BaseButton;
    import SingleDungeon.model.MapSceneModel;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import flash.utils.setInterval;
    import flash.utils.clearInterval;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.LeavePageManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;

    public class CDView extends Sprite implements Disposeable 
    {

        private var _CDbg:ScaleBitmapImage;
        private var _CDtimerText:FilterFrameText;
        private var _CDFFButton:BaseButton;
        private var intervalID:uint;
        private var _timerDown:int = 0;
        private var _info:MapSceneModel;
        private var _alertFrame:BaseAlerFrame;

        public function CDView(_arg_1:MapSceneModel)
        {
            this._info = _arg_1;
            this._timerDown = this._info.cdColling;
        }

        public function showCD():void
        {
            this._CDbg = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.CDBG");
            this._CDtimerText = ComponentFactory.Instance.creatComponentByStylename("singledungeon.CDtimerText");
            this._CDFFButton = ComponentFactory.Instance.creatComponentByStylename("singledungeon.CDFFButton");
            this.addChild(this._CDbg);
            this.addChild(this._CDtimerText);
            this.addChild(this._CDFFButton);
            this._CDtimerText.text = this._timerDown.toString();
            this._CDFFButton.addEventListener(MouseEvent.CLICK, this.__CDFFClick);
            this.intervalID = setInterval(this.updateCD, 1000);
            this.updateTime(this._timerDown);
        }

        private function updateCD():void
        {
            this._timerDown--;
            this.updateTime(this._timerDown);
            if (this._timerDown == 0)
            {
                this._info.cdColling = 0;
                clearInterval(this.intervalID);
                this.dispose();
            };
        }

        private function updateTime(_arg_1:int):void
        {
            var _local_2:int = _arg_1;
            var _local_3:int = int(((_local_2 / 60) / 60));
            var _local_4:int = int((_local_2 / 60));
            var _local_5:int = (_local_2 % 60);
            var _local_6:String = "";
            if (_local_3 < 10)
            {
                _local_6 = (_local_6 + ("0" + _local_3));
            }
            else
            {
                _local_6 = (_local_6 + _local_3);
            };
            _local_6 = (_local_6 + ":");
            if (_local_4 < 10)
            {
                _local_6 = (_local_6 + ("0" + _local_4));
            }
            else
            {
                _local_6 = (_local_6 + _local_4);
            };
            _local_6 = (_local_6 + ":");
            if (_local_5 < 10)
            {
                _local_6 = (_local_6 + ("0" + _local_5));
            }
            else
            {
                _local_6 = (_local_6 + _local_5);
            };
            this._CDtimerText.text = _local_6;
        }

        private function __CDFFClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:AlertInfo = new AlertInfo();
            _local_2.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _local_2.data = LanguageMgr.GetTranslation("singleDungeon.bissionView.immedEnterFrame", this._info.CoolMoney);
            _local_2.enableHtml = true;
            _local_2.moveEnable = false;
            this._alertFrame = AlertManager.Instance.alert("SimpleAlert", _local_2, LayerManager.ALPHA_BLOCKGOUND);
            this._alertFrame.addEventListener(FrameEvent.RESPONSE, this.__frameResponse);
        }

        private function __frameResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (PlayerManager.Instance.Self.totalMoney < Number(this._info.CoolMoney))
                {
                    LeavePageManager.showFillFrame();
                }
                else
                {
                    SocketManager.Instance.out.sendEnterRemoveCD(this._info.ID);
                };
            };
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse);
            this._alertFrame.dispose();
        }

        public function dispose():void
        {
            clearInterval(this.intervalID);
            ObjectUtils.disposeObject(this._CDbg);
            this._CDbg = null;
            ObjectUtils.disposeObject(this._CDtimerText);
            this._CDtimerText = null;
            ObjectUtils.disposeObject(this._CDFFButton);
            this._CDFFButton = null;
            ObjectUtils.disposeObject(this._alertFrame);
            this._alertFrame = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package SingleDungeon.view

