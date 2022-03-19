// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//setting.view.SettingView

package setting.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.controls.Silder;
    import flash.display.MovieClip;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.loader.LoaderSavingManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.InteractiveEvent;
    import com.pickgliss.toplevel.StageReferance;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import setting.controll.SettingController;
    import ddt.manager.PlayerManager;
    import ddt.data.OpitionEnum;
    import ddt.manager.SocketManager;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PathManager;
    import ddt.manager.SharedManager;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.LayerManager;
    import flash.events.Event;

    public class SettingView extends BaseAlerFrame 
    {

        private var _bg:Scale9CornerImage;
        private var _bgI:Bitmap;
        private var _imgTitle1:Image;
        private var _imgTitle2:Image;
        private var _imgTitle3:Image;
        private var _bmpYpsz:Bitmap;
        private var _bmpXssz:Bitmap;
        private var _bmpGnsz:Bitmap;
        private var _cbBjyy:SelectedCheckButton;
        private var _cbYxyx:SelectedCheckButton;
        private var _cbFmpc:SelectedCheckButton;
        private var _cbWqtx:SelectedCheckButton;
        private var _cbLbgn:SelectedCheckButton;
        private var _cbJsyq:SelectedCheckButton;
        private var _cbSxts:SelectedCheckButton;
        private var _communityFunction:SelectedCheckButton;
        private var _refusedBeFriendBtn:SelectedCheckButton;
        private var _refusedPrivateChatBtn:SelectedCheckButton;
        private var _sliderBjyy:Silder;
        private var _sliderYxyx:Silder;
        private var _oldAllowMusic:Boolean;
        private var _oldAllowSound:Boolean;
        private var _oldShowParticle:Boolean;
        private var _oldShowBugle:Boolean;
        private var _oldShowInvate:Boolean;
        private var _oldFightModelPropCell:Boolean;
        private var _oldShowOL:Boolean;
        private var _oldisRecommend:Boolean;
        private var _oldMusicVolumn:Number;
        private var _oldSoundVolumn:Number;
        private var _oldIsCommunity:Boolean;
        private var _recommendHint:MovieClip;
        private var _smallText1:FilterFrameText;
        private var _smallText2:FilterFrameText;
        private var _bigText1:FilterFrameText;
        private var _bigText2:FilterFrameText;
        private var _clearCacheBtn:TextButton;
        private var _intCount:int = 0;

        public function SettingView()
        {
            this.initView();
            this.initEvent();
        }

        private function initEvent():void
        {
            this._imgTitle3.addEventListener(MouseEvent.CLICK, this.__onTitleClick);
            this._clearCacheBtn.addEventListener(MouseEvent.CLICK, this.__onClearClick);
        }

        private function __onClearClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            LoaderSavingManager.clearCache();
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("setting.clearCacheComplete"));
        }

        private function __onTitleClick(_arg_1:MouseEvent):void
        {
            this._intCount = (this._intCount + 1);
            if (this._intCount > 20)
            {
            };
        }

        override public function dispose():void
        {
            this._cbBjyy.removeEventListener(MouseEvent.CLICK, this.__audioSelect);
            this._cbYxyx.removeEventListener(MouseEvent.CLICK, this.__audioSelect);
            this._cbWqtx.removeEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            this._cbLbgn.removeEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            this._cbJsyq.removeEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            this._cbSxts.removeEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            this._communityFunction.removeEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            this._refusedBeFriendBtn.removeEventListener(MouseEvent.CLICK, this.__refusedBeFriendHandler);
            this._refusedPrivateChatBtn.removeEventListener(MouseEvent.CLICK, this.__refusedPrivateChat);
            this._imgTitle3.removeEventListener(MouseEvent.CLICK, this.__onTitleClick);
            this._sliderBjyy.removeEventListener(InteractiveEvent.STATE_CHANGED, this.__musicSliderChanged);
            this._sliderYxyx.removeEventListener(InteractiveEvent.STATE_CHANGED, this.__soundSliderChanged);
            this._clearCacheBtn.removeEventListener(MouseEvent.CLICK, this.__onClearClick);
            var _local_1:DisplayObject = (StageReferance.stage.focus as DisplayObject);
            if (((_local_1) && (contains(_local_1))))
            {
                StageReferance.stage.focus = null;
            };
            if (((this._recommendHint) && (this._recommendHint.parent)))
            {
                this._recommendHint.removeEventListener(MouseEvent.CLICK, this.__recommendHintClick);
                this._recommendHint.parent.removeChild(this._recommendHint);
                this._recommendHint = null;
            };
            ObjectUtils.disposeAllChildren(this);
            this._imgTitle1 = null;
            this._imgTitle2 = null;
            this._imgTitle3 = null;
            this._smallText1 = null;
            this._smallText2 = null;
            this._bigText1 = null;
            this._bigText2 = null;
            this._bmpYpsz = null;
            this._bmpXssz = null;
            this._bmpGnsz = null;
            this._cbBjyy = null;
            this._cbYxyx = null;
            this._cbWqtx = null;
            this._cbLbgn = null;
            this._cbJsyq = null;
            this._cbSxts = null;
            this._sliderBjyy = null;
            this._sliderYxyx = null;
            this._refusedBeFriendBtn = null;
            this._refusedPrivateChatBtn = null;
            super.dispose();
            SettingController.Instance.dispose();
        }

        private function __refusedPrivateChat(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            PlayerManager.Instance.Self.OptionOnOff = OpitionEnum.setOpitionState((!(this._refusedPrivateChatBtn.selected)), OpitionEnum.RefusedPrivateChat);
            SocketManager.Instance.out.sendOpition(PlayerManager.Instance.Self.OptionOnOff);
        }

        private function initView():void
        {
            var _local_1:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.game.ToolStripView.set"));
            _local_1.moveEnable = false;
            info = _local_1;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtsettingView.Bg");
            addToContent(this._bg);
            this._bgI = ComponentFactory.Instance.creatBitmap("asset.ddtsettingView.BgI");
            addToContent(this._bgI);
            this._imgTitle1 = ComponentFactory.Instance.creat("ddtsetting.VolumeSetting");
            addToContent(this._imgTitle1);
            this._imgTitle2 = ComponentFactory.Instance.creat("ddtsetting.DisplaySetting");
            addToContent(this._imgTitle2);
            this._imgTitle3 = ComponentFactory.Instance.creat("ddtsetting.FuncSetting");
            addToContent(this._imgTitle3);
            this._smallText1 = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.smallText1");
            this._smallText2 = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.smallText2");
            this._bigText1 = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.bigText1");
            this._bigText2 = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.bigText2");
            this._cbBjyy = ComponentFactory.Instance.creat("ddtsetting.BackgroundMusicCbn");
            this._cbBjyy.text = LanguageMgr.GetTranslation("setting.backgroundMusic");
            this._cbBjyy.addEventListener(MouseEvent.CLICK, this.__audioSelect);
            addToContent(this._cbBjyy);
            this._cbYxyx = ComponentFactory.Instance.creat("ddtsetting.GameMusicCbn");
            this._cbYxyx.text = LanguageMgr.GetTranslation("setting.gameMusic");
            this._cbYxyx.addEventListener(MouseEvent.CLICK, this.__audioSelect);
            addToContent(this._cbYxyx);
            this._cbFmpc = ComponentFactory.Instance.creat("ddtsetting.FinghtModelPropCellCbn");
            this._cbFmpc.text = LanguageMgr.GetTranslation("setting.fightModel");
            this._cbFmpc.addEventListener(MouseEvent.CLICK, this.__audioSelect);
            addToContent(this._cbFmpc);
            this._cbWqtx = ComponentFactory.Instance.creat("ddtsetting.WeaponEffectCbn");
            this._cbWqtx.text = LanguageMgr.GetTranslation("setting.weaponEffect");
            this._cbWqtx.addEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            addToContent(this._cbWqtx);
            this._cbLbgn = ComponentFactory.Instance.creat("ddtsetting.SpeakerFunctionCbn");
            this._cbLbgn.text = LanguageMgr.GetTranslation("setting.speakerFunction");
            this._cbLbgn.addEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            addToContent(this._cbLbgn);
            this._cbJsyq = ComponentFactory.Instance.creat("ddtsetting.AcceptInvitationCbn");
            this._cbJsyq.text = LanguageMgr.GetTranslation("setting.acceptInvitation");
            this._cbJsyq.addEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            addToContent(this._cbJsyq);
            this._cbSxts = ComponentFactory.Instance.creat("ddtsetting.OnlinePromptCbn");
            this._cbSxts.text = LanguageMgr.GetTranslation("setting.onlinePrompt");
            this._cbSxts.addEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            addToContent(this._cbSxts);
            this._communityFunction = ComponentFactory.Instance.creat("ddtsetting.CommunityFunctionCbn");
            this._communityFunction.text = LanguageMgr.GetTranslation("setting.communityFunction");
            this._communityFunction.addEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            addToContent(this._communityFunction);
            if (((!(PathManager.isVisibleExistBtn())) || (!(PathManager.CommunityExist()))))
            {
                this._communityFunction.visible = false;
            };
            this._refusedBeFriendBtn = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.AcceptAddingFriendsCbn");
            this._refusedBeFriendBtn.text = LanguageMgr.GetTranslation("setting.acceptAddingFriends");
            this._refusedBeFriendBtn.addEventListener(MouseEvent.CLICK, this.__refusedBeFriendHandler);
            addToContent(this._refusedBeFriendBtn);
            this._refusedPrivateChatBtn = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.RejectStrangerMessageCbn");
            this._refusedPrivateChatBtn.text = LanguageMgr.GetTranslation("setting.rejectStrangerMessage");
            this._refusedPrivateChatBtn.addEventListener(MouseEvent.CLICK, this.__refusedPrivateChat);
            addToContent(this._refusedPrivateChatBtn);
            this._sliderBjyy = ComponentFactory.Instance.creat("ddtsetting.BackgroundMusicSlider");
            this._sliderBjyy.addEventListener(InteractiveEvent.STATE_CHANGED, this.__musicSliderChanged);
            addToContent(this._sliderBjyy);
            this._sliderYxyx = ComponentFactory.Instance.creat("ddtsetting.GameMusicSlider");
            this._sliderYxyx.addEventListener(InteractiveEvent.STATE_CHANGED, this.__soundSliderChanged);
            addToContent(this._sliderYxyx);
            addToContent(this._smallText1);
            addToContent(this._smallText2);
            addToContent(this._bigText1);
            addToContent(this._bigText2);
            this._clearCacheBtn = ComponentFactory.Instance.creatComponentByStylename("ddtsetting.clearCacheBtn");
            this._clearCacheBtn.text = LanguageMgr.GetTranslation("ddt.setting.clearCache.Txt");
            addToContent(this._clearCacheBtn);
            this.initData();
        }

        private function initData():void
        {
            this._oldAllowMusic = (this.allowMusic = SharedManager.Instance.allowMusic);
            this._oldAllowSound = (this.allowSound = SharedManager.Instance.allowSound);
            this._oldShowParticle = (this.particle = SharedManager.Instance.showParticle);
            this._oldShowBugle = (this.showbugle = SharedManager.Instance.showTopMessageBar);
            this._oldShowInvate = (this.invate = SharedManager.Instance.showInvateWindow);
            this._oldFightModelPropCell = (this.fightModelPropCellNow = SharedManager.Instance.fightModelPropCell);
            this._oldShowOL = (this.showOL = SharedManager.Instance.showOL);
            this._oldMusicVolumn = (this.musicVolumn = SharedManager.Instance.musicVolumn);
            this._oldSoundVolumn = (this.soundVolumn = SharedManager.Instance.soundVolumn);
            this._refusedBeFriendBtn.selected = (!(PlayerManager.Instance.Self.getOptionState(OpitionEnum.RefusedBeFriend)));
            this._refusedPrivateChatBtn.selected = (!(PlayerManager.Instance.Self.getOptionState(OpitionEnum.RefusedPrivateChat)));
            this.sliderEnable(this._sliderBjyy, this.allowMusic);
            this.sliderEnable(this._sliderYxyx, this.allowSound);
            this._oldIsCommunity = (this.isCommunity = SharedManager.Instance.isCommunity);
        }

        public function setShowSettingMovie():void
        {
            if (SharedManager.Instance.isSetingMovieClip)
            {
                this._recommendHint = ComponentFactory.Instance.creat("asset.setting.RecommendHint");
                PositionUtils.setPos(this._recommendHint, "setting.recommendHintPos");
                LayerManager.Instance.addToLayer(this._recommendHint, LayerManager.GAME_TOP_LAYER, false);
                this._recommendHint.addEventListener(MouseEvent.CLICK, this.__recommendHintClick);
            };
        }

        private function get allowMusic():Boolean
        {
            return (this._cbBjyy.selected);
        }

        private function set allowMusic(_arg_1:Boolean):void
        {
            this._cbBjyy.selected = _arg_1;
        }

        private function get fightModelPropCellNow():Boolean
        {
            return (this._cbFmpc.selected);
        }

        private function set fightModelPropCellNow(_arg_1:Boolean):void
        {
            this._cbFmpc.selected = _arg_1;
        }

        private function get allowSound():Boolean
        {
            return (this._cbYxyx.selected);
        }

        private function set allowSound(_arg_1:Boolean):void
        {
            this._cbYxyx.selected = _arg_1;
        }

        private function get particle():Boolean
        {
            return (this._cbWqtx.selected);
        }

        private function set particle(_arg_1:Boolean):void
        {
            this._cbWqtx.selected = _arg_1;
        }

        private function get showbugle():Boolean
        {
            return (this._cbLbgn.selected);
        }

        private function set showbugle(_arg_1:Boolean):void
        {
            this._cbLbgn.selected = _arg_1;
        }

        private function get invate():Boolean
        {
            return (this._cbJsyq.selected);
        }

        private function set invate(_arg_1:Boolean):void
        {
            this._cbJsyq.selected = _arg_1;
        }

        private function get showOL():Boolean
        {
            return (this._cbSxts.selected);
        }

        private function set showOL(_arg_1:Boolean):void
        {
            this._cbSxts.selected = _arg_1;
        }

        private function get musicVolumn():int
        {
            return (this._sliderBjyy.value);
        }

        private function set musicVolumn(_arg_1:int):void
        {
            this._sliderBjyy.value = _arg_1;
        }

        private function get soundVolumn():int
        {
            return (this._sliderYxyx.value);
        }

        private function set soundVolumn(_arg_1:int):void
        {
            this._sliderYxyx.value = _arg_1;
        }

        private function audioChanged():void
        {
            SharedManager.Instance.changed();
        }

        private function get isCommunity():Boolean
        {
            return (this._communityFunction.selected);
        }

        private function set isCommunity(_arg_1:Boolean):void
        {
            this._communityFunction.selected = _arg_1;
        }

        private function revert():void
        {
            SharedManager.Instance.allowMusic = this._oldAllowMusic;
            SharedManager.Instance.allowSound = this._oldAllowSound;
            SharedManager.Instance.showParticle = this._oldShowParticle;
            SharedManager.Instance.showTopMessageBar = this._oldShowBugle;
            SharedManager.Instance.showInvateWindow = this._oldShowInvate;
            SharedManager.Instance.showOL = this._oldShowOL;
            SharedManager.Instance.musicVolumn = this._oldMusicVolumn;
            SharedManager.Instance.soundVolumn = this._oldSoundVolumn;
            SharedManager.Instance.isCommunity = this._oldIsCommunity;
            SharedManager.Instance.isRecommend = this._oldisRecommend;
            SharedManager.Instance.save();
        }

        public function doConfirm():void
        {
            SoundManager.instance.play("008");
            SharedManager.Instance.allowMusic = this.allowMusic;
            SharedManager.Instance.allowSound = this.allowSound;
            SharedManager.Instance.showParticle = this.particle;
            SharedManager.Instance.showTopMessageBar = this.showbugle;
            SharedManager.Instance.showInvateWindow = this.invate;
            SharedManager.Instance.showOL = this.showOL;
            SharedManager.Instance.fightModelPropCell = this.fightModelPropCellNow;
            SharedManager.Instance.musicVolumn = this.musicVolumn;
            SharedManager.Instance.soundVolumn = this.soundVolumn;
            SharedManager.Instance.isCommunity = this.isCommunity;
            SharedManager.Instance.save();
        }

        public function doCancel():void
        {
            SoundManager.instance.play("008");
            this.revert();
        }

        private function sliderEnable(_arg_1:Silder, _arg_2:Boolean):void
        {
            var _local_3:Array;
            _arg_1.mouseChildren = _arg_2;
            _arg_1.mouseEnabled = _arg_2;
            if (_arg_2)
            {
                _arg_1.filters = null;
            }
            else
            {
                _local_3 = [ComponentFactory.Instance.model.getSet("grayFilter")];
                _arg_1.filters = _local_3;
            };
        }

        private function __checkBoxClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        private function __recommendHintClick(_arg_1:MouseEvent):void
        {
            if (((this._recommendHint) && (this._recommendHint.parent)))
            {
                this._recommendHint.removeEventListener(MouseEvent.CLICK, this.__recommendHintClick);
                this._recommendHint.parent.removeChild(this._recommendHint);
            };
        }

        private function __audioSelect(_arg_1:MouseEvent):void
        {
            SharedManager.Instance.allowMusic = this.allowMusic;
            SharedManager.Instance.allowSound = this.allowSound;
            this.audioChanged();
            if (_arg_1.currentTarget == this._cbBjyy)
            {
                SoundManager.instance.play("008");
                this.sliderEnable(this._sliderBjyy, this.allowMusic);
            }
            else
            {
                if (_arg_1.currentTarget == this._cbYxyx)
                {
                    this.sliderEnable(this._sliderYxyx, this.allowSound);
                }
                else
                {
                    if (_arg_1.currentTarget == this._cbFmpc)
                    {
                        SoundManager.instance.play("008");
                    };
                };
            };
        }

        private function __musicSliderChanged(_arg_1:Event):void
        {
            SharedManager.Instance.musicVolumn = this.musicVolumn;
            this.audioChanged();
        }

        private function __soundSliderChanged(_arg_1:Event):void
        {
            SharedManager.Instance.soundVolumn = this.soundVolumn;
            this.audioChanged();
        }

        private function __refusedBeFriendHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            PlayerManager.Instance.Self.OptionOnOff = OpitionEnum.setOpitionState((!(this._refusedBeFriendBtn.selected)), OpitionEnum.RefusedBeFriend);
            SocketManager.Instance.out.sendOpition(PlayerManager.Instance.Self.OptionOnOff);
        }


    }
}//package setting.view

