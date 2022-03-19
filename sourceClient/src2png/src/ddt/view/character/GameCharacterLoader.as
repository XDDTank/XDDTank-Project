// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.GameCharacterLoader

package ddt.view.character
{
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.ItemManager;
    import flash.display.BlendMode;
    import flash.display.MovieClip;
    import ddt.data.EquipType;
    import ddt.data.goods.ItemTemplateInfo;
    import __AS3__.vec.*;

    public class GameCharacterLoader extends BaseCharacterLoader 
    {

        public static var MALE_STATES:Array = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [7, 7], [8, 8], [11, 9]];
        public static var FEMALE_STATES:Array = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [7, 6], [9, 8], [11, 9]];

        private var _sp:Vector.<BitmapData>;
        private var _faceup:BitmapData;
        private var _face:BitmapData;
        private var _lackHpFace:Vector.<BitmapData>;
        private var _faceDown:BitmapData;
        private var _normalSuit:BitmapData;
        private var _lackHpSuit:BitmapData;
        public var specialType:int = -1;
        public var stateType:int = -1;

        public function GameCharacterLoader(_arg_1:PlayerInfo)
        {
            super(_arg_1);
        }

        public function get STATES_ENUM():Array
        {
            if (_info.Sex)
            {
                return (MALE_STATES);
            };
            return (FEMALE_STATES);
        }

        override protected function initLayers():void
        {
            var _local_1:ILayer;
            var _local_2:Array;
            var _local_3:int;
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
            if (_info.getShowSuits())
            {
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[7].split("|")[0])), _info.Sex, _recordColor[7], BaseLayer.GAME));
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[7].split("|")[0])), _info.Sex, _recordColor[7], BaseLayer.GAME, false, 1, null, "1"));
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[6].split("|")[0])), _info.Sex, _recordColor[6], BaseLayer.GAME, true, 1, _recordStyle[6].split("|")[1]));
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[8].split("|")[0])), _info.Sex, _recordColor[8], BaseLayer.GAME));
            }
            else
            {
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[1].split("|")[0])), _info.Sex, _recordColor[1], BaseLayer.GAME));
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[0].split("|")[0])), _info.Sex, _recordColor[0], BaseLayer.GAME));
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[3].split("|")[0])), _info.Sex, _recordColor[3], BaseLayer.GAME));
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[4].split("|")[0])), _info.Sex, _recordColor[4], BaseLayer.GAME));
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[2].split("|")[0])), _info.Sex, _recordColor[2], BaseLayer.GAME, false, _info.getHairType()));
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[5].split("|")[0])), _info.Sex, _recordColor[5], BaseLayer.GAME));
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[6].split("|")[0])), _info.Sex, _recordColor[6], BaseLayer.GAME, true, 1, _recordStyle[6].split("|")[1]));
                _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[8].split("|")[0])), _info.Sex, _recordColor[8], BaseLayer.GAME));
                _local_2 = this.STATES_ENUM;
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[5].split("|")[0])), _info.Sex, _recordColor[5], LayerFactory.STATE, false, 1, null, String(_local_2[_local_3][0])));
                    _layers.push(_layerFactory.createLayer(null, _info.Sex, "", LayerFactory.SPECIAL_EFFECT, false, 1, null, String(_local_2[_local_3][1])));
                    _local_3++;
                };
            };
        }

        override protected function getIndexByTemplateId(_arg_1:String):int
        {
            switch (_arg_1.charAt(0))
            {
                case "1":
                    if (_arg_1.charAt(1) == String(3))
                    {
                        return (0);
                    };
                    if (_arg_1.charAt(1) == String(5))
                    {
                        return (8);
                    };
                    return (1);
                case "2":
                    return (0);
                case "3":
                    return (4);
                case "4":
                    return (3);
                case "5":
                    return (4);
                case "6":
                    return (5);
                case "7":
                    return (7);
                default:
                    return (-1);
            };
        }

        override protected function drawCharacter():void
        {
            if (_info.getShowSuits())
            {
                this.drawSuits();
            }
            else
            {
                this.drawNormal();
            };
        }

        private function drawSuits():void
        {
            var _local_1:Number = _layers[1].width;
            var _local_2:Number = _layers[1].height;
            if (((_local_1 == 0) || (_local_2 == 0)))
            {
                return;
            };
            if (this._normalSuit)
            {
                this._normalSuit.dispose();
            };
            this._normalSuit = new BitmapData(_local_1, _local_2, true, 0);
            if (this._lackHpSuit)
            {
                this._lackHpSuit.dispose();
            };
            this._lackHpSuit = new BitmapData(_local_1, _local_2, true, 0);
            this._normalSuit.draw((_layers[2] as ILayer).getContent(), null, null, BlendMode.NORMAL);
            this._lackHpSuit.draw((_layers[2] as ILayer).getContent(), null, null, BlendMode.NORMAL);
            this._normalSuit.draw((_layers[0] as ILayer).getContent(), null, null, BlendMode.NORMAL);
            this._lackHpSuit.draw((_layers[1] as ILayer).getContent(), null, null, BlendMode.NORMAL);
            _wing = (_layers[3].getContent() as MovieClip);
        }

        private function drawNormal():void
        {
            var _local_7:BitmapData;
            var _local_8:BitmapData;
            var _local_9:BitmapData;
            var _local_10:BitmapData;
            var _local_1:Number = _layers[1].width;
            var _local_2:Number = _layers[1].height;
            if (((_local_1 == 0) || (_local_2 == 0)))
            {
                return;
            };
            if (this._face)
            {
                this._face.dispose();
            };
            this._face = new BitmapData(_local_1, _local_2, true, 0);
            if (this._faceup)
            {
                this._faceup.dispose();
            };
            this._faceup = new BitmapData(_local_1, _local_2, true, 0);
            if (this._sp)
            {
                for each (_local_7 in this._sp)
                {
                    _local_7.dispose();
                };
            };
            this._sp = new Vector.<BitmapData>();
            if (this._lackHpFace)
            {
                for each (_local_8 in this._lackHpFace)
                {
                    _local_8.dispose();
                };
            };
            this._lackHpFace = new Vector.<BitmapData>();
            if (this._faceDown)
            {
                this._faceDown.dispose();
            };
            this._faceDown = new BitmapData(_local_1, _local_2, true, 0);
            var _local_3:int = 7;
            while (_local_3 >= 0)
            {
                if (_layers[_local_3].info.CategoryID == EquipType.WING)
                {
                    _wing = (_layers[_local_3].getContent() as MovieClip);
                }
                else
                {
                    if (_local_3 == 5)
                    {
                        this._face.draw((_layers[_local_3] as ILayer).getContent(), null, null, BlendMode.NORMAL);
                    }
                    else
                    {
                        if (_local_3 == 6)
                        {
                            this._faceDown.draw((_layers[_local_3] as ILayer).getContent(), null, null, BlendMode.NORMAL);
                        }
                        else
                        {
                            if (_local_3 < 5)
                            {
                                this._faceup.draw((_layers[_local_3] as ILayer).getContent(), null, null, BlendMode.NORMAL);
                            };
                        };
                    };
                };
                _local_3--;
            };
            var _local_4:Number = _layers[8].width;
            var _local_5:Number = _layers[8].height;
            _local_4 = ((_local_4 == 0) ? 50 : _local_4);
            _local_5 = ((_local_5 == 0) ? 50 : _local_5);
            var _local_6:int = 8;
            while (_local_6 < _layers.length)
            {
                _local_9 = new BitmapData(_local_4, _local_5, true, 0);
                _local_10 = new BitmapData(_local_4, _local_5, true, 0);
                _local_9.draw((_layers[_local_6] as ILayer).getContent(), null, null, BlendMode.NORMAL);
                _local_10.draw((_layers[(_local_6 + 1)] as ILayer).getContent(), null, null, BlendMode.NORMAL);
                this._lackHpFace.push(_local_9);
                this._sp.push(_local_10);
                _local_6 = (_local_6 + 2);
            };
        }

        override public function getContent():Array
        {
            return ([_wing, this._sp, this._faceup, this._face, this._lackHpFace, this._faceDown, this._normalSuit, this._lackHpSuit]);
        }

        override protected function getCharacterLoader(_arg_1:ItemTemplateInfo, _arg_2:String="", _arg_3:String=null):ILayer
        {
            if (_arg_1.CategoryID == EquipType.HAIR)
            {
                return (_layerFactory.createLayer(_arg_1, _info.Sex, _arg_2, BaseLayer.GAME, false, _info.getHairType(), _arg_3));
            };
            return (_layerFactory.createLayer(_arg_1, _info.Sex, _arg_2, BaseLayer.GAME, false, 1, _arg_3));
        }

        override public function dispose():void
        {
            this._sp = null;
            this._faceup = null;
            this._face = null;
            this._lackHpFace = null;
            this._faceDown = null;
            this._normalSuit = null;
            this._lackHpSuit = null;
            super.dispose();
        }


    }
}//package ddt.view.character

