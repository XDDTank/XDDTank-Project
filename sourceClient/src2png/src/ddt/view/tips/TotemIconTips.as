// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.TotemIconTips

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.tip.ITip;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.player.PlayerInfo;
    import totem.data.TotemAddInfo;
    import com.pickgliss.ui.ComponentFactory;
    import totem.TotemManager;
    import com.pickgliss.utils.ObjectUtils;

    public class TotemIconTips extends BaseTip implements ITip, Disposeable 
    {

        public static const THISWIDTH:int = 120;

        private var _bg:ScaleBitmapImage;
        private var _tipTilte:FilterFrameText;
        private var _levelTxt:FilterFrameText;
        private var _playerInfo:PlayerInfo;
        private var _thisHeight:int;
        private var _totemInfo:TotemAddInfo;
        private var _contentTxt:FilterFrameText;


        override protected function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
            this._tipTilte = ComponentFactory.Instance.creatComponentByStylename("TotemIconTips.titleTxt");
            this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("TotemIconTips.titleTxt");
            this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("core.commonTipText");
            super.init();
            super.tipbackgound = this._bg;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._tipTilte);
            addChild(this._levelTxt);
            addChild(this._contentTxt);
            mouseChildren = false;
            mouseEnabled = false;
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            if (_arg_1)
            {
                this._playerInfo = (_arg_1 as PlayerInfo);
                if (this._playerInfo)
                {
                    this._totemInfo = TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(this._playerInfo.totemId));
                    this.visible = true;
                    this.setVisible(true);
                    this.upView();
                }
                else
                {
                    this.visible = true;
                    this.setVisible(false);
                    this._contentTxt.text = _arg_1.toString();
                    this.updateTransform();
                };
            }
            else
            {
                this.visible = false;
            };
        }

        private function upView():void
        {
            this._thisHeight = 0;
            this.showHeadPart();
            this.upBackground();
        }

        private function updateTransform():void
        {
            this._bg.width = (this._contentTxt.width + 16);
            this._bg.height = (this._contentTxt.height + 8);
            this._contentTxt.x = (this._bg.x + 8);
            this._contentTxt.y = (this._bg.y + 4);
            this.updateWH();
        }

        private function setVisible(_arg_1:Boolean):void
        {
            this._tipTilte.visible = _arg_1;
            this._levelTxt.visible = _arg_1;
            this._contentTxt.visible = (!(_arg_1));
        }

        private function showHeadPart():void
        {
            var _local_1:int = TotemManager.instance.getTotemPointLevel(this._playerInfo.totemId);
            this._tipTilte.text = "图腾等级:";
            this._levelTxt.text = (TotemManager.instance.getCurrentLv(_local_1).toString() + "级");
            this._levelTxt.x = ((this._tipTilte.x + this._tipTilte.textWidth) + 8);
            this._thisHeight = ((this._tipTilte.y + this._tipTilte.textHeight) + 12);
        }

        private function upBackground():void
        {
            this._bg.height = this._thisHeight;
            this._bg.width = THISWIDTH;
            this.updateWH();
        }

        private function updateWH():void
        {
            _width = this._bg.width;
            _height = this._bg.height;
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeAllChildren(this);
            this._tipTilte = null;
            this._levelTxt = null;
            this._playerInfo = null;
        }


    }
}//package ddt.view.tips

