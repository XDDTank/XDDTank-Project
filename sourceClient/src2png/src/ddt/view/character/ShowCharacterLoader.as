// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.ShowCharacterLoader

package ddt.view.character
{
    import flash.display.BitmapData;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.ItemManager;
    import ddt.data.EquipType;
    import flash.display.DisplayObject;
    import flash.geom.Matrix;
    import flash.display.MovieClip;
    import flash.display.BlendMode;
    import __AS3__.vec.*;

    public class ShowCharacterLoader extends BaseCharacterLoader 
    {

        protected var _contentWithoutWeapon:BitmapData;
        private var _needMultiFrames:Boolean = false;

        public function ShowCharacterLoader(_arg_1:PlayerInfo)
        {
            super(_arg_1);
        }

        override protected function initLayers():void
        {
            var _local_1:ILayer;
            if (_layers != null)
            {
                for each (_local_1 in _layers)
                {
                    _local_1.dispose();
                };
                _layers = null;
            };
            _layers = new Vector.<ILayer>();
            _recordStyle = _info.Style.split(",");
            _recordColor = _info.Colors.split(",");
            this.loadPart(7);
            this.loadPart(1);
            this.loadPart(0);
            this.loadPart(3);
            this.loadPart(4);
            this.loadPart(2);
            this.loadPart(5);
            this.laodArm();
            this.loadPart(8);
        }

        private function loadPart(_arg_1:int):void
        {
            if (_recordStyle[_arg_1].split("|")[0] > 0)
            {
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[_arg_1].split("|")[0])), _info.Sex, _recordColor[_arg_1], BaseLayer.SHOW, (_arg_1 == 2), _info.getHairType()));
            };
        }

        private function laodArm():void
        {
            if (_recordStyle[6].split("|")[0] > 0)
            {
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[6].split("|")[0])), _info.Sex, _recordColor[6], BaseLayer.SHOW, false, _info.getHairType(), _recordStyle[6].split("|")[1]));
            };
        }

        override protected function getIndexByTemplateId(_arg_1:String):int
        {
            var _local_2:int = super.getIndexByTemplateId(_arg_1);
            if (_local_2 == -1)
            {
                if (int(_arg_1.charAt(0)) == EquipType.ARM)
                {
                    return (7);
                };
                return (-1);
            };
            return (_local_2);
        }

        public function set needMultiFrames(_arg_1:Boolean):void
        {
            this._needMultiFrames = _arg_1;
        }

        override protected function drawCharacter():void
        {
            var _local_3:DisplayObject;
            var _local_6:ILayer;
            var _local_1:Number = ShowCharacter.BIG_WIDTH;
            var _local_2:Number = ShowCharacter.BIG_HEIGHT;
            if (this._needMultiFrames)
            {
                _local_1 = (_local_1 * 2);
            };
            if (_content)
            {
                _content.dispose();
            };
            if (this._contentWithoutWeapon)
            {
                this._contentWithoutWeapon.dispose();
            };
            _content = new BitmapData(_local_1, _local_2, true, 0);
            this._contentWithoutWeapon = new BitmapData(_local_1, _local_2, true, 0);
            var _local_4:Matrix = new Matrix();
            _local_4.identity();
            _local_4.translate((_local_1 / 2), 0);
            var _local_5:int = (_layers.length - 1);
            for (;_local_5 >= 0;_local_5--)
            {
                if (_info.getShowSuits())
                {
                    if ((((!(_local_5 == 0)) && (!(_local_5 == 8))) && (!(_local_5 == 7)))) continue;
                }
                else
                {
                    if (_local_5 == 0) continue;
                };
                _local_6 = _layers[_local_5];
                if ((!(EquipType.isWeapon(_local_6.info.TemplateID))))
                {
                    if (_local_6.info.CategoryID == EquipType.WING)
                    {
                        _wing = (_local_6.getContent() as MovieClip);
                    }
                    else
                    {
                        if (((!(_local_6.info.CategoryID == EquipType.FACE)) && (!(_local_6.info.CategoryID == EquipType.SUITS))))
                        {
                            this._contentWithoutWeapon.draw(_local_6.getContent(), null, null, BlendMode.NORMAL);
                            if (this._needMultiFrames)
                            {
                                this._contentWithoutWeapon.draw(_local_6.getContent(), _local_4, null, BlendMode.NORMAL);
                            };
                        }
                        else
                        {
                            this._contentWithoutWeapon.draw(_local_6.getContent(), null, null, BlendMode.NORMAL);
                        };
                    };
                }
                else
                {
                    if (((!(_info.WeaponID == 0)) && (!(_info.WeaponID == -1))))
                    {
                        _local_3 = _local_6.getContent();
                    };
                };
            };
            _content.draw(this._contentWithoutWeapon);
            if (_local_3 != null)
            {
                _content.draw(_local_3);
            };
        }

        override public function dispose():void
        {
            super.dispose();
            _content = null;
            this._contentWithoutWeapon = null;
        }

        public function destory():void
        {
            _content.dispose();
            this._contentWithoutWeapon.dispose();
            this.dispose();
        }

        override public function getContent():Array
        {
            return ([_content, this._contentWithoutWeapon, _wing]);
        }


    }
}//package ddt.view.character

