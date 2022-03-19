// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ViceChairmanItem

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import ddt.view.common.LevelIcon;
    import ddt.view.common.SexIcon;
    import ddt.data.player.ConsortiaPlayerInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.player.BasePlayer;
    import flash.text.TextFormat;
    import ddt.manager.PlayerManager;
    import vip.VipController;

    public class ViceChairmanItem extends Sprite implements Disposeable 
    {

        private var _itemBg:Bitmap;
        private var _light:Bitmap;
        private var _name:FilterFrameText;
        private var _vipName:GradientText;
        private var _levelIcon:LevelIcon;
        private var _SexIcon:SexIcon;
        private var _playerInfo:ConsortiaPlayerInfo;
        private var _isSelected:Boolean = false;

        public function ViceChairmanItem()
        {
            this.initView();
        }

        private function initView():void
        {
            this._itemBg = ComponentFactory.Instance.creatBitmap("consortionTrasfer.itemBg");
            this._light = ComponentFactory.Instance.creatBitmap("consortionTrasfer.light");
            this._light.visible = false;
            this._name = ComponentFactory.Instance.creatComponentByStylename("memberItem.commonName");
            this._levelIcon = ComponentFactory.Instance.creatCustomObject("memberItem.level");
            this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
            this._SexIcon = ComponentFactory.Instance.creatCustomObject("consortionTrasfer.itemSexIcon");
            PositionUtils.setPos(this._name, "asset.viceChairmanItemNameTxt.pos");
            PositionUtils.setPos(this._levelIcon, "asset.viceChairmanItemlevelIcon.pos");
            PositionUtils.setPos(this._SexIcon, "asset.viceChairmanItemSexIcon.pos");
            addChild(this._itemBg);
            addChild(this._light);
        }

        public function get info():ConsortiaPlayerInfo
        {
            return (this._playerInfo);
        }

        public function set info(_arg_1:ConsortiaPlayerInfo):void
        {
            this._playerInfo = _arg_1;
            if (this._playerInfo == null)
            {
                this.isSelelct = false;
                mouseEnabled = false;
                mouseChildren = false;
            }
            else
            {
                mouseEnabled = true;
                mouseChildren = true;
                this.setName();
                ObjectUtils.disposeObject(this._levelIcon);
                ObjectUtils.disposeObject(this._SexIcon);
                this._levelIcon = ComponentFactory.Instance.creatCustomObject("memberItem.level");
                this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
                this._SexIcon = ComponentFactory.Instance.creatCustomObject("consortionTrasfer.itemSexIcon");
                PositionUtils.setPos(this._levelIcon, "asset.viceChairmanItemlevelIcon.pos");
                PositionUtils.setPos(this._SexIcon, "asset.viceChairmanItemSexIcon.pos");
                addChild(this._levelIcon);
                addChild(this._SexIcon);
                this._levelIcon.setInfo(this._playerInfo.Grade, this._playerInfo.Repute, this._playerInfo.WinCount, this._playerInfo.TotalCount, this._playerInfo.FightPower, this._playerInfo.Offer);
                this._SexIcon.setSex(this._playerInfo.Sex);
            };
        }

        private function setName():void
        {
            var _local_1:BasePlayer;
            var _local_2:TextFormat;
            if (this._playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
                _local_1 = PlayerManager.Instance.Self;
            }
            else
            {
                _local_1 = this._playerInfo;
            };
            ObjectUtils.disposeObject(this._name);
            this._name = ComponentFactory.Instance.creatComponentByStylename("memberItem.commonName");
            this._name.text = _local_1.NickName;
            PositionUtils.setPos(this._name, "asset.viceChairmanItemNameTxt.pos");
            addChild(this._name);
            if (_local_1.IsVIP)
            {
                ObjectUtils.disposeObject(this._vipName);
                this._vipName = VipController.instance.getVipNameTxt(149, _local_1.VIPtype);
                _local_2 = new TextFormat();
                _local_2.align = "center";
                _local_2.bold = true;
                this._vipName.textField.defaultTextFormat = _local_2;
                this._vipName.textSize = 16;
                PositionUtils.setPos(this._vipName, "asset.viceChairmanItemNameTxt.pos");
                this._vipName.text = _local_1.NickName;
                addChild(this._vipName);
            };
            PositionUtils.adaptNameStyle(_local_1, this._name, this._vipName);
        }

        public function get isSelelct():Boolean
        {
            return (this._isSelected);
        }

        public function set isSelelct(_arg_1:Boolean):void
        {
            if (this._isSelected == _arg_1)
            {
                return;
            };
            this._isSelected = _arg_1;
            this._light.visible = this._isSelected;
        }

        public function set light(_arg_1:Boolean):void
        {
            if (this._isSelected)
            {
                return;
            };
            this._light.visible = _arg_1;
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._itemBg = null;
            this._light = null;
            this._name = null;
            this._levelIcon = null;
            this._vipName = null;
            this._SexIcon = null;
            this._playerInfo = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

