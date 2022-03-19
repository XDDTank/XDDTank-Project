// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.SmallPlayerDetailTip

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.tip.ITip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.Sprite;
    import ddt.view.common.LevelIcon;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import petsBag.view.item.PetSmallItem;
    import game.model.Player;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.DisplayObject;
    import flash.display.BitmapData;
    import com.pickgliss.utils.ObjectUtils;
    import flash.geom.Point;
    import com.pickgliss.utils.DisplayUtils;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;

    public class SmallPlayerDetailTip extends BaseTip implements ITip 
    {

        private var _bg:ScaleBitmapImage;
        private var _playerAsset:Sprite;
        private var _levelIcon:LevelIcon;
        private var _nameTxt:FilterFrameText;
        private var _consortiaTxt:FilterFrameText;
        private var _splitImg:Bitmap;
        private var _winPercentTxt:FilterFrameText;
        private var _fightNum:FilterFrameText;
        private var _split2Img:Bitmap;
        private var _petAsset:PetSmallItem;
        private var _petNameTxt:FilterFrameText;
        private var _petLevelTxt:FilterFrameText;
        private var _playerImg:Bitmap;
        private var _info:Player;
        private var _bgH:int;


        override protected function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("game.smallPlayerTip.bg");
            this._tipbackgound = this._bg;
            this._playerAsset = ComponentFactory.Instance.creat("game.smallPlayerTip.playerAsset");
            this._levelIcon = new LevelIcon();
            this._nameTxt = ComponentFactory.Instance.creat("game.smallPlayerTip.nameTxt");
            this._consortiaTxt = ComponentFactory.Instance.creat("game.smallPlayerTip.consortiaTxt");
            this._splitImg = ComponentFactory.Instance.creat("asset.game.smallPlayerTip.split");
            this._winPercentTxt = ComponentFactory.Instance.creat("game.smallPlayerTip.winPercentTxt");
            this._fightNum = ComponentFactory.Instance.creat("game.smallPlayerTip.fightNumTxt");
            this._split2Img = ComponentFactory.Instance.creat("asset.game.smallPlayerTip.split");
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(0, 0);
            _local_1.graphics.drawRect(0, 0, 50, 50);
            _local_1.graphics.endFill();
            this._petAsset = new PetSmallItem(_local_1);
            this._petNameTxt = ComponentFactory.Instance.creat("game.smallPlayerTip.petNameTxt");
            this._petLevelTxt = ComponentFactory.Instance.creat("game.smallPlayerTip.petLevelTxt");
            super.init();
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._playerAsset);
            addChild(this._levelIcon);
            addChild(this._nameTxt);
            addChild(this._consortiaTxt);
            addChild(this._splitImg);
            addChild(this._winPercentTxt);
            addChild(this._fightNum);
            addChild(this._split2Img);
            addChild(this._petAsset);
            addChild(this._petNameTxt);
            addChild(this._petLevelTxt);
        }

        override public function get tipData():Object
        {
            return (this._info);
        }

        override public function set tipData(_arg_1:Object):void
        {
            var _local_2:DisplayObject;
            var _local_3:BitmapData;
            this._info = (_arg_1 as Player);
            if (this._petAsset)
            {
                if (this._petAsset.info)
                {
                    this._petAsset.info = null;
                };
            };
            ObjectUtils.disposeObject(this._playerImg);
            this._playerImg = null;
            if (this._info)
            {
                if (this._info.playerInfo)
                {
                    this._info.character.showGun = false;
                    this._info.character.showWing = false;
                    this._info.character.setShowLight(true, new Point(0, 2));
                    _local_2 = this._info.character.getShowBitmapBig();
                    _local_3 = new BitmapData(_local_2.width, _local_2.height, true, 0);
                    _local_3.draw(_local_2);
                    this._playerImg = new Bitmap(_local_3, "auto", true);
                    this._playerImg.scaleX = -1;
                    if (((this._info.playerInfo.getShowSuits()) && (this._info.playerInfo.getSuitsType() == 1)))
                    {
                        this._playerImg.y = -18;
                    }
                    else
                    {
                        this._playerImg.y = -3;
                    };
                    this._playerImg.x = (this._playerImg.width * 0.5);
                    this._playerAsset.addChild(this._playerImg);
                    this._levelIcon.setInfo(this._info.playerInfo.Grade, this._info.playerInfo.Repute, this._info.playerInfo.WinCount, this._info.playerInfo.TotalCount, this._info.playerInfo.FightPower, this._info.playerInfo.Offer, true, false, this._info.team);
                    this._nameTxt.text = DisplayUtils.subStringByLength(this._nameTxt, this._info.playerInfo.NickName, 100);
                    if (this._info.playerInfo.ConsortiaID != 0)
                    {
                        this._consortiaTxt.text = (("<" + this._info.playerInfo.ConsortiaName) + ">");
                    }
                    else
                    {
                        this._consortiaTxt.text = "";
                    };
                    this._winPercentTxt.htmlText = LanguageMgr.GetTranslation("game.smallPlayerDetailTip.winRate", Number(((this._info.playerInfo.TotalCount == 0) ? 0 : ((this._info.playerInfo.WinCount / this._info.playerInfo.TotalCount) * 100))).toFixed(2));
                    this._fightNum.htmlText = LanguageMgr.GetTranslation("game.smallPlayerDetailTip.fightNum", this._info.playerInfo.FightPower);
                    this._petAsset.info = this._info.playerInfo.currentPet;
                    if (this._info.playerInfo.currentPet)
                    {
                        this._petNameTxt.text = this._info.playerInfo.currentPet.Name;
                        this._petLevelTxt.text = ("Lv." + String(this._info.playerInfo.currentPet.Level));
                    }
                    else
                    {
                        this._petNameTxt.text = "";
                        this._petLevelTxt.text = "";
                    };
                    this.fixPos();
                };
            };
            this.updateWH();
        }

        private function fixPos():void
        {
            if (((!(this._info.isBoss)) && (this._info.playerInfo.currentPet)))
            {
                PositionUtils.setPos(this._levelIcon, "game.smallPlayerTip.levelIconPos1");
                PositionUtils.setPos(this._nameTxt, "game.smallPlayerTip.nameTxtPos1");
                PositionUtils.setPos(this._consortiaTxt, "game.smallPlayerTip.consortiaTxtPos1");
                PositionUtils.setPos(this._splitImg, "game.smallPlayerTip.splitPosPos1");
                PositionUtils.setPos(this._winPercentTxt, "game.smallPlayerTip.winPercentTxtPos1");
                PositionUtils.setPos(this._fightNum, "game.smallPlayerTip.fightNumTxtPos1");
                PositionUtils.setPos(this._split2Img, "game.smallPlayerTip.splitPos2Pos1");
                PositionUtils.setPos(this._petAsset, "game.smallPlayerTip.petItemPos1");
                PositionUtils.setPos(this._petNameTxt, "game.smallPlayerTip.petNameTxtPos1");
                PositionUtils.setPos(this._petLevelTxt, "game.smallPlayerTip.petLevelTxtPos1");
                this._split2Img.visible = true;
                this._petAsset.visible = true;
                this._petNameTxt.visible = true;
                this._petLevelTxt.visible = true;
            }
            else
            {
                PositionUtils.setPos(this._levelIcon, "game.smallPlayerTip.levelIconPos2");
                PositionUtils.setPos(this._nameTxt, "game.smallPlayerTip.nameTxtPos2");
                PositionUtils.setPos(this._consortiaTxt, "game.smallPlayerTip.consortiaTxtPos2");
                PositionUtils.setPos(this._splitImg, "game.smallPlayerTip.splitPosPos2");
                PositionUtils.setPos(this._winPercentTxt, "game.smallPlayerTip.winPercentTxtPos2");
                PositionUtils.setPos(this._fightNum, "game.smallPlayerTip.fightNumTxtPos2");
                this._split2Img.visible = false;
                this._petAsset.visible = false;
                this._petNameTxt.visible = false;
                this._petLevelTxt.visible = false;
            };
        }

        private function updateWH():void
        {
            _width = (this._bg.width + 10);
            _height = this._bg.height;
        }

        override public function dispose():void
        {
        }


    }
}//package ddt.view.tips

