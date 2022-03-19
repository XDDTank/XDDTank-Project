// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//par.renderer.DisplayObjectRenderer

package par.renderer
{
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import par.particals.Particle;
    import __AS3__.vec.Vector;
    import flash.display.BlendMode;

    public class DisplayObjectRenderer extends Sprite implements IParticleRenderer 
    {

        private var layers:Dictionary;

        public function DisplayObjectRenderer()
        {
            mouseEnabled = false;
            mouseChildren = false;
            this.layers = new Dictionary();
        }

        public function renderParticles(_arg_1:Vector.<Particle>):void
        {
            var _local_2:Particle;
            for each (_local_2 in _arg_1)
            {
                _local_2.image.transform.colorTransform = _local_2.colorTransform;
                _local_2.image.transform.matrix = _local_2.matrixTransform;
            };
        }

        public function addParticle(_arg_1:Particle):void
        {
            var _local_2:Sprite = this.layers[_arg_1.info];
            if (_local_2 == null)
            {
                this.layers[_arg_1.info] = (_local_2 = new Sprite());
                _local_2.blendMode = BlendMode.LAYER;
                addChild(_local_2);
            };
            if (_arg_1.info.keepOldFirst)
            {
                _local_2.addChild(_arg_1.image);
            }
            else
            {
                _local_2.addChildAt(_arg_1.image, 0);
            };
        }

        public function removeParticle(_arg_1:Particle):void
        {
            var _local_2:Sprite = this.layers[_arg_1.info];
            if (((_local_2) && (_local_2.contains(_arg_1.image))))
            {
                _local_2.removeChild(_arg_1.image);
            };
        }

        public function reset():void
        {
            this.layers = new Dictionary();
            var _local_1:Number = numChildren;
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                this.removeChildAt(0);
                _local_2++;
            };
        }

        public function dispose():void
        {
        }


    }
}//package par.renderer

