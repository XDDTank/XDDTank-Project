// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ConsortionInfoViewFrame

package consortion.view.selfConsortia
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import ddt.data.ConsortiaInfo;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import consortion.ConsortionModelControl;
    import __AS3__.vec.Vector;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SocketManager;
    import consortion.data.ConsortiaLevelInfo;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ConsortionInfoViewFrame extends Frame 
    {

        private var _bg:Scale9CornerImage;
        private var _bgI:Scale9CornerImage;
        private var _bgII:Scale9CornerImage;
        private var _buildBg:Bitmap;
        private var _buildBgI:Bitmap;
        private var _buildBgII:Bitmap;
        private var _gradeBg:Bitmap;
        private var _inputBg:Scale9CornerImage;
        private var _inputBgI:Scale9CornerImage;
        private var _inputBgII:Scale9CornerImage;
        private var _inputBgV:Scale9CornerImage;
        private var _consortionName:FilterFrameText;
        private var _consortionRank:FilterFrameText;
        private var _consortionMember:FilterFrameText;
        private var _chairman:FilterFrameText;
        private var _namtTxt:FilterFrameText;
        private var _rankTxt:FilterFrameText;
        private var _numTxt:FilterFrameText;
        private var _charimanTxt:FilterFrameText;
        private var _hallLvTxt:FilterFrameText;
        private var _shopLvTxt:FilterFrameText;
        private var _skillLvTxt:FilterFrameText;
        private var _placardImage:Bitmap;
        private var _placardTxt:FilterFrameText;
        private var _level:ScaleFrameImage;
        private var _info:ConsortiaInfo;
        private var _levelProgress:ConsortionInfoViewLevelProgress;
        private var _takeInBtn:BaseButton;

        public function ConsortionInfoViewFrame()
        {
            escEnable = true;
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            titleText = "查看公会";
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.bg");
            this._bgI = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.bgI");
            this._bgII = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.bgII");
            this._buildBg = ComponentFactory.Instance.creatBitmap("asset.consortion.checkHall");
            this._buildBgI = ComponentFactory.Instance.creatBitmap("asset.consortion.checkShop");
            this._buildBgII = ComponentFactory.Instance.creatBitmap("asset.consortion.checkSkill");
            this._gradeBg = ComponentFactory.Instance.creatBitmap("asset.consortion.checkGrade");
            this._inputBg = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.InputBg");
            this._inputBgI = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.InputBgI");
            this._inputBgII = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.InputBgII");
            this._inputBgV = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.InputBgV");
            this._consortionName = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.ConsortionnameTxt");
            this._consortionRank = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.ConsortionRankTxt");
            this._consortionMember = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.ConsortionNumTxt");
            this._chairman = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.ChairNameTxt");
            this._consortionName.text = "公会名称";
            this._consortionRank.text = "排名";
            this._consortionMember.text = "人数";
            this._chairman.text = "会长";
            this._namtTxt = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.nameText");
            this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.Rankext");
            this._numTxt = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.NumText");
            this._charimanTxt = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.chariNameText");
            this._placardImage = ComponentFactory.Instance.creatBitmap("asset.conortionAnnouncement.Image");
            PositionUtils.setPos(this._placardImage, "asset.ConsortionInfoViewFrame.Pos");
            this._level = ComponentFactory.Instance.creatComponentByStylename("consortion.level");
            this._level.scaleX = 0.65;
            this._level.scaleY = 0.65;
            PositionUtils.setPos(this._level, "asset.ConsortionInfoViewFrame.LevelPos");
            this._hallLvTxt = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.HallLvText");
            this._shopLvTxt = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.ShopLvText");
            this._skillLvTxt = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.SkillLvText");
            this._placardTxt = ComponentFactory.Instance.creatComponentByStylename("ConsorionInfoViewFrame.placardText");
            this._levelProgress = ComponentFactory.Instance.creatComponentByStylename("ConsortionInfoViewLevelProgress");
            this._takeInBtn = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.takeInBtn");
            addToContent(this._bg);
            addToContent(this._bgI);
            addToContent(this._bgII);
            addToContent(this._buildBg);
            addToContent(this._buildBgI);
            addToContent(this._buildBgII);
            addToContent(this._gradeBg);
            addToContent(this._inputBg);
            addToContent(this._inputBgI);
            addToContent(this._inputBgII);
            addToContent(this._inputBgV);
            addToContent(this._consortionName);
            addToContent(this._consortionRank);
            addToContent(this._consortionMember);
            addToContent(this._chairman);
            addToContent(this._placardImage);
            addToContent(this._namtTxt);
            addToContent(this._rankTxt);
            addToContent(this._numTxt);
            addToContent(this._charimanTxt);
            addToContent(this._level);
            addToContent(this._hallLvTxt);
            addToContent(this._shopLvTxt);
            addToContent(this._skillLvTxt);
            addToContent(this._placardTxt);
            addToContent(this._levelProgress);
            addToContent(this._takeInBtn);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
            this._takeInBtn.addEventListener(MouseEvent.CLICK, this.__takeIn);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__response);
            this._takeInBtn.removeEventListener(MouseEvent.CLICK, this.__takeIn);
        }

        private function __response(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        private function __takeIn(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:Vector.<ConsortiaInfo> = ConsortionModelControl.Instance.model.readyApplyList;
            if (PlayerManager.Instance.Self.Grade < 13)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.playerTip.notInvite"));
                return;
            };
            if ((!(this._info.OpenApply)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.applyJoinClickHandler"));
                return;
            };
            if (((_local_2) && (_local_2.length >= 10)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.applyJoinClickHandlerFill"));
                return;
            };
            this._info.IsApply = true;
            SocketManager.Instance.out.sendConsortiaTryIn(this._info.ConsortiaID);
            this.dispose();
        }

        public function set info(_arg_1:ConsortiaInfo):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:ConsortiaLevelInfo;
            this._info = _arg_1;
            if (this._info == null)
            {
                return;
            };
            var _local_2:ConsortiaLevelInfo = ConsortionModelControl.Instance.model.getLevelData(((this._info.Level == 10) ? this._info.Level : (this._info.Level + 1)));
            this._level.setFrame(this._info.Level);
            this._namtTxt.text = this._info.ConsortiaName;
            this._rankTxt.text = this._info.Repute.toString();
            this._numTxt.text = this._info.Count.toString();
            this._charimanTxt.text = this._info.ChairmanName;
            this._hallLvTxt.text = ("Lv." + this._info.StoreLevel.toString());
            this._shopLvTxt.text = ("Lv." + this._info.ShopLevel.toString());
            this._skillLvTxt.text = ("Lv." + this._info.SmithLevel.toString());
            if (this._info.Level <= 1)
            {
                _local_3 = this._info.Experience;
                _local_4 = _local_2.Experience;
            }
            else
            {
                _local_5 = ConsortionModelControl.Instance.model.getLevelData(this._info.Level);
                _local_3 = (this._info.Experience - _local_5.Experience);
                _local_4 = (_local_2.Experience - _local_5.Experience);
            };
            this._levelProgress.setProgress(Number(_local_3), Number(_local_4));
            if (this._info.Placard == "")
            {
                this._placardTxt.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.systemWord");
            }
            else
            {
                this._placardTxt.text = this._info.Placard;
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            this.removeEvent();
            this._bg = null;
            this._bgI = null;
            this._bgII = null;
            this._buildBg = null;
            this._buildBgI = null;
            this._buildBgII = null;
            this._gradeBg = null;
            this._inputBg = null;
            this._inputBgI = null;
            this._inputBgII = null;
            this._inputBgV = null;
            this._consortionName = null;
            this._consortionRank = null;
            this._consortionMember = null;
            this._chairman = null;
            this._placardImage = null;
            this._namtTxt = null;
            this._rankTxt = null;
            this._numTxt = null;
            this._charimanTxt = null;
            this._level = null;
            this._hallLvTxt = null;
            this._shopLvTxt = null;
            this._skillLvTxt = null;
            this._placardTxt = null;
            this._levelProgress = null;
            ObjectUtils.disposeAllChildren(this);
            super.dispose();
        }


    }
}//package consortion.view.selfConsortia

