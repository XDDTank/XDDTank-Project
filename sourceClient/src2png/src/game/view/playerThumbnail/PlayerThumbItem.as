// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.playerThumbnail.PlayerThumbItem

package game.view.playerThumbnail
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import game.model.Player;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.BitmapManager;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;

    public class PlayerThumbItem extends Sprite implements Disposeable 
    {

        private var _info:Player;
        private var _headFigure:HeadFigure;
        private var _bg:Bitmap;
        private var _fore:Bitmap;
        private var _vip:DisplayObject;
        private var _dirct:int;

        public function PlayerThumbItem(_arg_1:Player, _arg_2:int=0)
        {
            this._info = _arg_1;
            this._dirct = _arg_2;
            this.init();
        }

        protected function init():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.back");
            addChild(this._bg);
            this._headFigure = new HeadFigure(36, 36, this._info);
            if ((!(this._info.isLiving)))
            {
                this._headFigure.gray();
            };
            this._headFigure.y = 3;
            addChild(this._headFigure);
            this._fore = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.fore");
            this._fore.x = (this._fore.y = 1);
            addChild(this._fore);
            if (this._info.playerInfo.IsVIP)
            {
                this._vip = BitmapManager.getBitmapMgr(BitmapManager.GameView).creatBitmapShape("asset.game.smallplayer.vip");
                addChild(this._vip);
            };
            if (this._dirct == -1)
            {
                this._headFigure.scaleX = -(this._headFigure.scaleX);
                this._headFigure.x = 42;
                if (this._vip)
                {
                    PositionUtils.setPos(this._vip, "asset.game.smallplayer.vipPos1");
                };
            }
            else
            {
                this._headFigure.x = 4;
                if (this._vip)
                {
                    PositionUtils.setPos(this._vip, "asset.game.smallplayer.vipPos2");
                };
            };
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._headFigure);
            this._headFigure = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._fore);
            this._fore = null;
            ObjectUtils.disposeObject(this._vip);
            this._vip = null;
            ObjectUtils.disposeObject(this._headFigure);
            this._headFigure = null;
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.playerThumbnail

