// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.VaneView

package game.view
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.geom.Point;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.filters.GlowFilter;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import flash.text.TextFieldAutoSize;
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.geom.Matrix;
    import com.pickgliss.utils.ObjectUtils;

    public class VaneView extends Sprite 
    {

        public static const RandomVaneOffset:Number = 6;
        public static const RANDOW_COLORS:Array = [0x1A1A1A, 1514802, 1712150, 2493709, 1713677, 1838339, 1842464, 2170141, 1054500, 2630187];
        public static const RANDOW_COLORSII:Array = [[4667276, 2429483], [11785, 0x562D00], [401937, 608599], [473932, 6492176], [9178527, 1316390], [2360854, 7280322], [2185247, 927056], [8724255, 4076052], [0x1C0096, 0x470035], [919557, 7353207], [1644310, 5703976], [149007, 857625], [2499109, 872256], [0x820000, 1328498], [5775151, 3355404], [1326929, 7150931]];

        private var _bmVaneTitle:Bitmap;
        private var _bmPreviousDirection:Bitmap;
        private var _bmPrevious:Bitmap;
        private var vane1_mc:MovieClip;
        private var mixedbgAccect:Shape;
        private var _lastWind:Number;
        private var mixedBg1:CheckCodeMixedBack;
        private var vane1PosX:Number = 0;
        private var vane2PosX:Number = -17.5;
        private var text1PosX:Number = 0;
        private var text2PosX:Number = 0;
        private var _vanePos:Point;
        private var _vanePos2:Point;
        private var _vaneTitlePos:Point;
        private var _vaneTitlePos1:Point;
        private var _vaneTitlePos2:Point;
        private var _vaneValuePos:Point;
        private var _vaneValuePos2:Point;
        private var _field:FilterFrameText;
        private var _vanePreviousGradientText:FilterFrameText;
        private var textGlowFilter:GlowFilter;
        private var textFilter:Array;
        private var _previousDirectionPos:Point;
        private var _valuePos1:Point;
        private var _valuePos2:Point;
        private var _zeroTxt:FilterFrameText;
        private var _windNumShape:Shape;

        public function VaneView():void
        {
            this._vanePos = ComponentFactory.Instance.creatCustomObject("asset.game.vaneAssetPos");
            this._vanePos2 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneAssetPos2");
            this._vaneTitlePos = ComponentFactory.Instance.creatCustomObject("asset.game.vaneTitleAssetPos");
            this._vaneTitlePos1 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneTitleAssetPos1");
            this._vaneTitlePos2 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneTitleAssetPos2");
            this._vaneValuePos = ComponentFactory.Instance.creatCustomObject("asset.game.vaneValueAssetPos");
            this._vaneValuePos2 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneValueAssetPos2");
            this._bmVaneTitle = ComponentFactory.Instance.creatBitmap("asset.game.vaneTitleAsset");
            this._bmVaneTitle.x = this._vaneTitlePos1.x;
            addChild(this._bmVaneTitle);
            this._bmPrevious = ComponentFactory.Instance.creatBitmap("asset.game.vanePreviousAsset");
            this._bmPrevious.visible = false;
            addChild(this._bmPrevious);
            this._bmPreviousDirection = ComponentFactory.Instance.creatBitmap("asset.game.vanePreviousDirectionAsset");
            this._previousDirectionPos = new Point(this._bmPreviousDirection.x, this._bmPreviousDirection.y);
            this._bmPreviousDirection.visible = false;
            addChild(this._bmPreviousDirection);
            this._vanePreviousGradientText = ComponentFactory.Instance.creatComponentByStylename("asset.game.vanePreviousGradientTextAsset");
            this._vanePreviousGradientText.visible = false;
            addChild(this._vanePreviousGradientText);
            this._zeroTxt = ComponentFactory.Instance.creatComponentByStylename("asset.game.vaneZeroTextAsset");
            this.vane1_mc = ClassUtils.CreatInstance("asset.game.vaneAsset");
            this.vane1_mc.mouseChildren = (this.vane1_mc.mouseEnabled = false);
            this.vane1_mc.x = this._vanePos.x;
            this.vane1_mc.y = this._vanePos.y;
            addChild(this.vane1_mc);
            this.mixedbgAccect = new Shape();
            this.mixedbgAccect.graphics.beginFill(0xFFFFFF, 1);
            this.mixedbgAccect.graphics.drawRect(0, 0, 20, 20);
            this.mixedbgAccect.graphics.endFill();
            this.creatGraidenText();
            this.creatMixBg();
            mouseChildren = (mouseEnabled = false);
        }

        private function creatMixBg():void
        {
            this.mixedBg1 = new CheckCodeMixedBack(20, 20, 7238008);
            this.mixedBg1.x = 0;
            this.mixedBg1.y = 0;
            this.mixedBg1.mask = this.mixedbgAccect;
        }

        public function setUpCenter(_arg_1:Number, _arg_2:Number):void
        {
            this.x = _arg_1;
            this.y = _arg_2;
        }

        private function getRandomVaneOffset():Number
        {
            return ((Math.random() * RandomVaneOffset) - (RandomVaneOffset / 2));
        }

        private function creatGraidenText():void
        {
            this._field = ComponentFactory.Instance.creatComponentByStylename("asset.game.vaneGradientTextAsset");
            this._field.autoSize = TextFieldAutoSize.CENTER;
            this._valuePos1 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneValueAssetPos");
            this._valuePos2 = ComponentFactory.Instance.creatCustomObject("asset.game.vaneValueAssetPos2");
            this._windNumShape = new Shape();
            addChildAt(this._windNumShape, numChildren);
        }

        public function initialize():void
        {
            this._lastWind = 11;
        }

        public function update(_arg_1:Number, _arg_2:Boolean=false, _arg_3:Array=null):void
        {
            if (_arg_3 == null)
            {
                this._windNumShape.visible = false;
                _arg_3 = new Array();
                _arg_3 = [true, 0, 0, 0];
            }
            else
            {
                this._windNumShape.visible = true;
            };
            if (this._lastWind != 11)
            {
                this.lastTurn(this._lastWind);
            };
            if (_arg_2)
            {
                this._lastWind = _arg_1;
            };
            if (_arg_1 != 0)
            {
                this._bmVaneTitle.x = ((_arg_3[0] == true) ? this._vaneTitlePos2.x : this._vaneTitlePos.x);
            };
            this.vane1_mc.scaleX = ((_arg_3[0] == true) ? 1 : -1);
            this.vane1_mc.x = ((_arg_3[0] == true) ? this._vanePos2.x : this._vanePos.x);
            this._windNumShape.x = ((_arg_3[0] == true) ? this._vaneValuePos.x : this._vaneValuePos2.x);
            this._windNumShape.y = ((_arg_3[0] == true) ? this._vaneValuePos.y : this._vaneValuePos2.y);
            if ((((_arg_3[1] == 0) && (_arg_3[2] == 0)) && (_arg_3[3] == 0)))
            {
                this._zeroTxt.x = this._windNumShape.x;
                this._zeroTxt.y = this._windNumShape.y;
                addChild(this._zeroTxt);
                this._windNumShape.visible = false;
                this._zeroTxt.visible = true;
            }
            else
            {
                this._windNumShape.visible = true;
                this._zeroTxt.visible = false;
                this.drawNum([_arg_3[1], _arg_3[2], _arg_3[3]]);
            };
        }

        private function drawNum(_arg_1:Array):void
        {
            var _local_4:BitmapData;
            var _local_5:int;
            var _local_2:Graphics = this._windNumShape.graphics;
            _local_2.clear();
            var _local_3:Matrix = new Matrix();
            for each (_local_5 in _arg_1)
            {
                _local_4 = WindPowerManager.Instance.getWindPicById(_local_5);
                if (_local_4)
                {
                    _local_3.tx = this._windNumShape.width;
                    _local_2.beginBitmapFill(_local_4, _local_3);
                    _local_2.drawRect(this._windNumShape.width, 0, _local_4.width, _local_4.height);
                    _local_2.endFill();
                };
            };
        }

        private function setRandomPos():void
        {
            var _local_1:Number = this.getRandomVaneOffset();
            this.vane1_mc.x = (this.vane1_mc.x + _local_1);
            this._windNumShape.x = (this._windNumShape.x + _local_1);
        }

        private function addZero(_arg_1:Number):String
        {
            var _local_2:String;
            if (((Math.ceil(_arg_1) == _arg_1) || (Math.floor(_arg_1) == _arg_1)))
            {
                _local_2 = (Math.abs(_arg_1).toString() + ".0");
            }
            else
            {
                _local_2 = Math.abs(_arg_1).toString();
            };
            return (_local_2);
        }

        private function lastTurn(_arg_1:Number):void
        {
            this._bmPrevious.visible = true;
            this._bmPreviousDirection.visible = true;
            this._vanePreviousGradientText.visible = true;
            this._bmPreviousDirection.scaleX = ((_arg_1 > 0) ? 1 : -1);
            this._bmPreviousDirection.x = ((_arg_1 > 0) ? this._previousDirectionPos.x : (this._previousDirectionPos.x + this._bmPreviousDirection.width));
            this._vanePreviousGradientText.text = Math.abs(_arg_1).toString();
        }

        public function dispose():void
        {
            if (this._bmVaneTitle)
            {
                if (this._bmVaneTitle.parent)
                {
                    this._bmVaneTitle.parent.removeChild(this._bmVaneTitle);
                };
                this._bmVaneTitle.bitmapData.dispose();
                this._bmVaneTitle = null;
            };
            if (this._bmPreviousDirection)
            {
                if (this._bmPreviousDirection.parent)
                {
                    this._bmPreviousDirection.parent.removeChild(this._bmPreviousDirection);
                };
                this._bmPreviousDirection.bitmapData.dispose();
                this._bmPreviousDirection = null;
            };
            if (this._bmPrevious)
            {
                if (this._bmPrevious.parent)
                {
                    this._bmPrevious.parent.removeChild(this._bmPrevious);
                };
                this._bmPrevious.bitmapData.dispose();
                this._bmPrevious = null;
            };
            this.vane1_mc.stop();
            removeChild(this.vane1_mc);
            this.vane1_mc = null;
            this.mixedbgAccect = null;
            this.mixedBg1.mask = null;
            this.mixedBg1 = null;
            ObjectUtils.disposeObject(this._windNumShape);
            this._windNumShape = null;
            if (this._zeroTxt)
            {
                ObjectUtils.disposeObject(this._zeroTxt);
            };
            this._zeroTxt = null;
            ObjectUtils.disposeObject(this._vanePreviousGradientText);
            this._vanePreviousGradientText = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view

