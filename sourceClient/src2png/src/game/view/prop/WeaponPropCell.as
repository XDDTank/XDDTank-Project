// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.WeaponPropCell

package game.view.prop
{
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.EquipType;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.manager.BitmapManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.PropInfo;
    import com.pickgliss.loader.LoaderEvent;
    import flash.events.MouseEvent;

    public class WeaponPropCell extends PropCell 
    {

        private var _bg:Bitmap;
        private var _countField:FilterFrameText;
        private var _bitmap:Bitmap;

        public function WeaponPropCell(_arg_1:String, _arg_2:int)
        {
            super(_arg_1, _arg_2);
        }

        private static function creatDeputyWeaponIcon(_arg_1:int):Bitmap
        {
            switch (_arg_1)
            {
                case EquipType.Angle:
                    return (ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop29Asset"));
                case EquipType.TrueAngle:
                    return (ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop30Asset"));
                case EquipType.ExllenceAngle:
                    return (ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop35Asset"));
                case EquipType.FlyAngle:
                    return (ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop36Asset"));
                case EquipType.TrueShield:
                    return (ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop31Asset"));
                case EquipType.ExcellentShield:
                    return (ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop32Asset"));
                case EquipType.FlyAngleOne:
                    return (ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop40Asset"));
                case EquipType.WishKingBlessing:
                    return (ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop41Asset"));
                case EquipType.PYX1:
                    return (ComponentFactory.Instance.creatBitmap("game.crazyTank.view.Prop50Asset"));
                default:
                    return (null);
            };
        }


        override public function setPossiton(_arg_1:int, _arg_2:int):void
        {
            super.setPossiton(_arg_1, _arg_2);
            this.x = _x;
            this.y = _y;
        }

        override protected function drawLayer():void
        {
        }

        override protected function configUI():void
        {
            super.configUI();
            this._countField = ComponentFactory.Instance.creatComponentByStylename("game.PropCell.CountField");
            addChild(this._countField);
        }

        public function setCount(_arg_1:int):void
        {
            this._countField.text = _arg_1.toString();
            this._countField.x = (_back.width - this._countField.width);
            this._countField.y = (_back.height - this._countField.height);
        }

        override public function set info(val:PropInfo):void
        {
            var asset:DisplayObject;
            ShowTipManager.Instance.removeTip(this);
            _info = val;
            asset = _asset;
            if (_info != null)
            {
                if ((((!(_info.Template.CategoryID == EquipType.HOLYGRAIL)) && (!(_info.Template.CategoryID == EquipType.TEMP_OFFHAND))) || (_info.Template.TemplateID == 17200)))
                {
                    try
                    {
                        this._bitmap = ComponentFactory.Instance.creatBitmap((("game.crazyTank.view.Prop" + _info.Template.Pic) + "Asset"));
                        this.setBitmap();
                    }
                    catch(err:Error)
                    {
                        BitmapManager.LoadPic(loadPicComplete, _info.Template);
                    };
                }
                else
                {
                    this._bitmap = creatDeputyWeaponIcon(_info.TemplateID);
                };
                _tipInfo.info = _info.Template;
                _tipInfo.shortcutKey = _shortcutKey;
                ShowTipManager.Instance.addTip(this);
                buttonMode = true;
            }
            else
            {
                buttonMode = false;
            };
            if (asset != null)
            {
                ObjectUtils.disposeObject(asset);
            };
            this._countField.visible = ((!(_info == null)) || (!(_asset == null)));
        }

        private function loadPicComplete(_arg_1:LoaderEvent):void
        {
            if (_arg_1.loader.isSuccess)
            {
                this._bitmap = Bitmap(_arg_1.loader.content);
                this.setBitmap();
            };
        }

        private function setBitmap():void
        {
            if (((this._bitmap) && (_fore)))
            {
                this._bitmap.smoothing = true;
                this._bitmap.x = (this._bitmap.y = 3);
                this._bitmap.width = (this._bitmap.height = 32);
                addChildAt(this._bitmap, getChildIndex(_fore));
            };
            _asset = this._bitmap;
        }

        override public function useProp():void
        {
            if (((_info) || (_asset)))
            {
                dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            };
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._countField);
            this._countField = null;
            ObjectUtils.disposeObject(this._bitmap);
            this._bitmap = null;
            ShowTipManager.Instance.removeTip(this);
            super.dispose();
        }


    }
}//package game.view.prop

