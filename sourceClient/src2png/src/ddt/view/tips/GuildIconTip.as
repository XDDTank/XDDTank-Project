// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.GuildIconTip

package ddt.view.tips
{
    import flash.display.Sprite;
    import com.pickgliss.ui.tip.ITip;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.vo.DirectionPos;

    public class GuildIconTip extends Sprite implements ITip, Disposeable 
    {

        private var _tipData:GuildIconTipInfo;
        private var _bg:ScaleBitmapImage;
        private var _guildLVTitle:Bitmap;
        private var _guildLV:Sprite;
        private var _stateTitle:Bitmap;
        private var _stateTxt:FilterFrameText;
        private var _repute:GuildRepute;

        public function GuildIconTip()
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.guildIconTipBg");
            addChild(this._bg);
            this._guildLVTitle = ComponentFactory.Instance.creatBitmap("asset.core.guildLevelAsset");
            addChild(this._guildLVTitle);
            this._stateTitle = ComponentFactory.Instance.creatBitmap("asset.core.consortiaTip.StatePic");
            addChild(this._stateTitle);
            this._stateTxt = ComponentFactory.Instance.creatComponentByStylename("core.guildStateTxt");
            addChild(this._stateTxt);
            this._repute = ComponentFactory.Instance.creatCustomObject("asset.core.guildRepute");
            addChild(this._repute);
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function set tipData(_arg_1:Object):void
        {
            if (_arg_1)
            {
                this._tipData = (_arg_1 as GuildIconTipInfo);
                if (this._guildLV)
                {
                    ObjectUtils.disposeAllChildren(this._guildLV);
                    ObjectUtils.disposeObject(this._guildLV);
                };
                this._guildLV = LevelPicCreater.creatLelvePic(this._tipData.Level);
                PositionUtils.setPos(this._guildLV, "asset.core.guildLevelPos");
                addChild(this._guildLV);
                this._repute.setRepute(this._tipData.Repute);
                if (this._tipData.State == GuildIconTipInfo.ENEMY)
                {
                    this._stateTxt.text = LanguageMgr.GetTranslation("tank.view.common.ConsortiaIcon.enemy");
                    this._stateTxt.textColor = 16718863;
                }
                else
                {
                    if (this._tipData.State == GuildIconTipInfo.MEMBER)
                    {
                        this._stateTxt.text = LanguageMgr.GetTranslation("tank.view.common.ConsortiaIcon.self");
                        this._stateTxt.textColor = 61183;
                    }
                    else
                    {
                        this._stateTxt.text = LanguageMgr.GetTranslation("tank.view.common.ConsortiaIcon.middle");
                        this._stateTxt.textColor = 5898001;
                    };
                };
            };
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this._guildLV);
            this._guildLV = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get currentDirectionPos():DirectionPos
        {
            return (null);
        }

        public function set currentDirectionPos(_arg_1:DirectionPos):void
        {
        }


    }
}//package ddt.view.tips

