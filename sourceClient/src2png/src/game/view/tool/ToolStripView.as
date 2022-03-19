// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.tool.ToolStripView

package game.view.tool
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.SelectedButton;
    import ddt.view.chat.RightChatFacePanel;
    import game.model.LocalPlayer;
    import ddt.manager.TimeManager;
    import com.pickgliss.ui.ComponentFactory;
    import game.GameManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import im.IMController;
    import ddt.manager.PlayerManager;
    import room.model.RoomInfo;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import org.aswing.KeyboardManager;
    import flash.ui.Keyboard;
    import ddt.manager.SoundManager;
    import ddt.manager.SharedManager;
    import ddt.manager.SavePointManager;
    import ddt.manager.MessageTipManager;
    import ddt.events.GameEvent;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.ChatManager;
    import setting.controll.SettingController;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.events.LivingEvent;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.manager.GameInSocketOut;

    public class ToolStripView extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _faceBtn:SimpleBitmapButton;
        private var _fastMovie:MovieClip;
        private var _fastChatBtn:SimpleBitmapButton;
        private var _bloodStrip:BloodStrip;
        private var _powerStrip:PowerStrip;
        private var _facePanelPos:Point;
        private var _center:Bitmap;
        private var _transparentBtn:BaseButton;
        private var _mouseStateBtn:SelectedButton;
        private var _startDate:Date;
        private var _facePanel:RightChatFacePanel;
        private var _danderBar:DanderBar;
        private var _self:LocalPlayer;
        private var _mouseState:Boolean;
        private var _frame:int;

        public function ToolStripView(_arg_1:LocalPlayer)
        {
            this._self = _arg_1;
            this.initView();
            this.initEvents();
            this._startDate = TimeManager.Instance.Now();
        }

        private function initView():void
        {
            mouseEnabled = false;
            this._bg = ComponentFactory.Instance.creatBitmap("asset.game.health.back");
            addChild(this._bg);
            this._bloodStrip = new BloodStrip();
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("asset.game.bloodStripPos");
            this._bloodStrip.x = _local_1.x;
            this._bloodStrip.y = _local_1.y;
            addChild(this._bloodStrip);
            this._danderBar = new DanderBar(GameManager.Instance.Current.selfGamePlayer, this);
            this._danderBar.x = 120;
            this._danderBar.y = 1;
            addChild(this._danderBar);
            this._faceBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.faceButton");
            this.setTip(this._faceBtn, LanguageMgr.GetTranslation("tank.game.ToolStripView.face"));
            addChild(this._faceBtn);
            this._fastChatBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.chatButton");
            this.setTip(this._fastChatBtn, LanguageMgr.GetTranslation("tank.game.ToolStripView.chat"));
            addChild(this._fastChatBtn);
            this._fastMovie = (ClassUtils.CreatInstance("asset.game.prop.chatMoive") as MovieClip);
            PositionUtils.setPos(this._fastMovie, "asset.game.chatmoviePos");
            this._fastChatBtn.addChild(this._fastMovie);
            if (((IMController.Instance.hasUnreadMessage()) && (!(IMController.Instance.cancelflashState))))
            {
                this._fastMovie.gotoAndPlay(1);
            }
            else
            {
                this._fastMovie.gotoAndStop(this._fastMovie.totalFrames);
            };
            this._facePanel = ComponentFactory.Instance.creatCustomObject("chat.rightFacePanel", [true]);
            this._facePanelPos = ComponentFactory.Instance.creatCustomObject("asset.game.facePanelView");
            this._powerStrip = new PowerStrip();
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("asset.game.powerStripPos");
            this._powerStrip.x = _local_2.x;
            this._powerStrip.y = _local_2.y;
            addChild(this._powerStrip);
            this._transparentBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.TransparentButton");
            this.setTip(this._transparentBtn, LanguageMgr.GetTranslation("tank.game.ToolStripView.transparent"));
            addChild(this._transparentBtn);
            this._mouseStateBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.mouseStateButton");
            if (PlayerManager.Instance.Self.Grade >= 13)
            {
                this._mouseStateBtn.visible = true;
                this._mouseState = this._self.mouseState;
            }
            else
            {
                this._mouseStateBtn.visible = false;
                this._mouseState = false;
            };
            if (this._mouseState)
            {
                this._mouseStateBtn.selected = true;
                this.setTip(this._mouseStateBtn, LanguageMgr.GetTranslation("tank.game.ToolStripView.keboardState"));
            }
            else
            {
                this._mouseStateBtn.selected = false;
                this.setTip(this._mouseStateBtn, LanguageMgr.GetTranslation("tank.game.ToolStripView.mouseState"));
            };
            addChild(this._mouseStateBtn);
            if (((GameManager.Instance.Current) && (GameManager.Instance.Current.roomType == RoomInfo.SINGLE_DUNGEON)))
            {
                this._faceBtn.enable = false;
            };
        }

        private function setTip(_arg_1:BaseButton, _arg_2:String):void
        {
            _arg_1.tipStyle = "ddt.view.tips.OneLineTip";
            _arg_1.tipDirctions = "0";
            _arg_1.tipGapV = 5;
            _arg_1.tipData = _arg_2;
        }

        private function initEvents():void
        {
            this._faceBtn.addEventListener(MouseEvent.CLICK, this.__face);
            this._fastChatBtn.addEventListener(MouseEvent.CLICK, this.__fastChat);
            this._fastChatBtn.addEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
            this._fastChatBtn.addEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
            this._facePanel.addEventListener(Event.SELECT, this.__onFaceSelect);
            this._transparentBtn.addEventListener(MouseEvent.CLICK, this.__transparentChanged);
            this._mouseStateBtn.addEventListener(MouseEvent.CLICK, this.__mouseStateChanged);
            IMController.Instance.addEventListener(IMController.HAS_NEW_MESSAGE, this.__hasNewHandler);
            IMController.Instance.addEventListener(IMController.NO_MESSAGE, this.__noMessageHandler);
        }

        protected function __noMessageHandler(_arg_1:Event):void
        {
            this._fastMovie.gotoAndStop(this._fastMovie.totalFrames);
        }

        protected function __hasNewHandler(_arg_1:Event):void
        {
            this._fastMovie.gotoAndPlay(1);
        }

        protected function __overHandler(_arg_1:MouseEvent):void
        {
            if (KeyboardManager.isDown(Keyboard.SPACE))
            {
                return;
            };
            IMController.Instance.showMessageBox(this._faceBtn);
        }

        protected function __outHandler(_arg_1:MouseEvent):void
        {
            IMController.Instance.hideMessageBox();
        }

        protected function __transparentChanged(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SharedManager.Instance.propTransparent = (!(SharedManager.Instance.propTransparent));
        }

        protected function __mouseStateChanged(_arg_1:MouseEvent):void
        {
            if ((!(SavePointManager.Instance.savePoints[28])))
            {
                if ((!(GameManager.Instance.Current.currentLiving)))
                {
                    return;
                };
                if (GameManager.Instance.Current.currentLiving.playerInfo != PlayerManager.Instance.Self)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
                    return;
                };
            };
            SoundManager.instance.playButtonSound();
            dispatchEvent(new GameEvent(GameEvent.MOUSE_STATE_CHANGE));
            this._mouseState = (!(this._mouseState));
            if (SavePointManager.Instance.isInSavePoint(19))
            {
                if (GameManager.Instance.Current.missionInfo.missionIndex == 1)
                {
                    if (NewHandContainer.Instance.hasArrow(ArrowType.TIP_POWERMODE))
                    {
                        NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_POWERMODE);
                        if (this._mouseState)
                        {
                            NewHandContainer.Instance.showArrow(ArrowType.TIP_POWERMODE, 0, "trainer.mouseModeClickPowerPos", "asset.trainer.clickUsePower", "trainer.mouseModeClickPowerTipPos");
                        }
                        else
                        {
                            NewHandContainer.Instance.showArrow(ArrowType.TIP_POWERMODE, 0, "trainer.clickPowerPos", "asset.trainer.clickUsePower", "trainer.clickPowerTipPos");
                        };
                    };
                };
            };
            if (NewHandContainer.Instance.hasArrow(ArrowType.TIP_USE_T))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_USE_T);
                if (this._mouseState)
                {
                    NewHandContainer.Instance.showArrow(ArrowType.TIP_USE_T, 0, "trainer.mouseModeClickTArrowPos", "", "");
                }
                else
                {
                    NewHandContainer.Instance.showArrow(ArrowType.TIP_USE_T, 0, "trainer.ClickTArrowPos", "", "");
                };
            };
            if (this._mouseState)
            {
                this._mouseStateBtn.selected = true;
                this.setTip(this._mouseStateBtn, LanguageMgr.GetTranslation("tank.game.ToolStripView.keboardState"));
            }
            else
            {
                this._mouseStateBtn.selected = false;
                this.setTip(this._mouseStateBtn, LanguageMgr.GetTranslation("tank.game.ToolStripView.mouseState"));
            };
        }

        private function removeEvents():void
        {
            this._fastChatBtn.removeEventListener(MouseEvent.CLICK, this.__fastChat);
            this._fastChatBtn.removeEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
            this._fastChatBtn.removeEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
            this._facePanel.removeEventListener(Event.SELECT, this.__onFaceSelect);
            this._transparentBtn.removeEventListener(MouseEvent.CLICK, this.__transparentChanged);
            this._mouseStateBtn.removeEventListener(MouseEvent.CLICK, this.__mouseStateChanged);
            IMController.Instance.removeEventListener(IMController.HAS_NEW_MESSAGE, this.__hasNewHandler);
            IMController.Instance.removeEventListener(IMController.NO_MESSAGE, this.__noMessageHandler);
        }

        public function dispose():void
        {
            this.removeEvents();
            this._facePanel.dispose();
            this._facePanel = null;
            if (this._bloodStrip)
            {
                if (this._bloodStrip.parent)
                {
                    this._bloodStrip.parent.removeChild(this._bloodStrip);
                };
                this._bloodStrip.dispose();
            };
            this._bloodStrip = null;
            if (this._powerStrip)
            {
                if (this._powerStrip.parent)
                {
                    this._powerStrip.parent.removeChild(this._powerStrip);
                };
                this._powerStrip.dispose();
            };
            this._powerStrip = null;
            if (this._faceBtn)
            {
                if (this._faceBtn.parent)
                {
                    this._faceBtn.parent.removeChild(this._faceBtn);
                };
                this._faceBtn.dispose();
            };
            if (this._fastMovie)
            {
                ObjectUtils.disposeObject(this._fastMovie);
                this._fastMovie = null;
            };
            this._faceBtn = null;
            if (this._fastChatBtn)
            {
                if (this._fastChatBtn.parent)
                {
                    this._fastChatBtn.parent.removeChild(this._fastChatBtn);
                };
                this._fastChatBtn.dispose();
            };
            this._fastChatBtn = null;
            ObjectUtils.disposeObject(this._danderBar);
            this._danderBar = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function __fastChat(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            ChatManager.Instance.switchVisible();
        }

        private function __setBtn(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SettingController.Instance.switchVisible();
        }

        private function __face(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._facePanel.x = localToGlobal(new Point(this._facePanelPos.x, this._facePanelPos.y)).x;
            this._facePanel.y = localToGlobal(new Point(this._facePanelPos.x, this._facePanelPos.y)).y;
            this._facePanel.setVisible = true;
        }

        private function __onFaceSelect(_arg_1:Event):void
        {
            ChatManager.Instance.sendFace(this._facePanel.selected);
            this._facePanel.setVisible = false;
            StageReferance.stage.focus = null;
        }

        private function __im(_arg_1:MouseEvent):void
        {
            IMController.Instance.switchVisible();
            SoundManager.instance.play("008");
        }

        private function updateDander(_arg_1:int):void
        {
        }

        private function __dander(_arg_1:LivingEvent):void
        {
            if (GameManager.Instance.Current.selfGamePlayer.isLiving)
            {
                this.updateDander(GameManager.Instance.Current.selfGamePlayer.dander);
            };
        }

        private function __ok():void
        {
            if (((StateManager.isInFight) || (StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)))
            {
                mouseChildren = false;
                GameInSocketOut.sendGamePlayerExit();
                SoundManager.instance.play("008");
            };
        }

        private function __cancel():void
        {
            SoundManager.instance.play("008");
        }

        private function __die(_arg_1:LivingEvent):void
        {
            this.updateDander(0);
            this.showDeadTip();
        }

        private function showDeadTip():void
        {
            if (GameManager.Instance.Current.selfGamePlayer.playerInfo.Grade >= 10)
            {
                return;
            };
            if ((!(GameManager.Instance.Current.haveAllias)))
            {
                return;
            };
        }

        public function set specialEnabled(_arg_1:Boolean):void
        {
            this._danderBar.specialEnabled = _arg_1;
        }

        public function setDanderEnable(_arg_1:Boolean):void
        {
            this._danderBar.setVisible(_arg_1);
        }


    }
}//package game.view.tool

