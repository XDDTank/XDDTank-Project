// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//par.particals.Particle

package par.particals
{
    import flash.display.DisplayObject;
    import par.ShapeManager;
    import par.lifeeasing.AbstractLifeEasing;
    import flash.geom.Point;
    import road7th.math.randRange;
    import flash.geom.Matrix;
    import flash.geom.ColorTransform;

    public class Particle 
    {

        public var x:Number;
        public var y:Number;
        public var alpha:Number;
        public var color:Number;
        public var scale:Number;
        public var rotation:Number;
        public var life:Number;
        public var age:Number;
        public var size:Number;
        public var v:Number;
        public var angle:Number;
        public var gv:Number;
        public var motionV:Number;
        public var weight:Number;
        public var spin:Number;
        public var image:DisplayObject;
        public var info:ParticleInfo;

        public function Particle(_arg_1:ParticleInfo)
        {
            this.image = ShapeManager.create(_arg_1.displayCreator);
            this.info = _arg_1;
            this.initialize();
        }

        public function initialize():void
        {
            this.x = 0;
            this.y = 0;
            this.color = 0;
            this.scale = 1;
            this.rotation = 0;
            this.age = 0;
            this.life = 1;
            this.alpha = 1;
            this.v = 0;
            this.angle = 0;
            this.gv = 0;
            if (this.image)
            {
                this.image.blendMode = this.info.blendMode;
            };
        }

        public function update(_arg_1:Number):void
        {
            var _local_2:Number = (this.age / this.life);
            var _local_3:AbstractLifeEasing = this.info.lifeEasing;
            this.v = _local_3.easingVelocity(this.v, _local_2);
            this.motionV = _local_3.easingRandomVelocity(this.motionV, _local_2);
            this.weight = _local_3.easingWeight(this.weight, _local_2);
            this.gv = (this.gv + this.weight);
            var _local_4:Point = Point.polar(this.v, this.angle);
            var _local_5:Point = Point.polar(this.motionV, randRange(0, (2 * Math.PI)));
            this.x = (this.x + ((_local_4.x + _local_5.x) * _arg_1));
            this.y = (this.y + (((_local_4.y + _local_5.y) + this.gv) * _arg_1));
            this.scale = _local_3.easingSize(this.size, _local_2);
            this.rotation = (this.rotation + (_local_3.easingSpinVelocity(this.spin, _local_2) * _arg_1));
            this.color = _local_3.easingColor(this.color, _local_2);
            this.alpha = _local_3.easingApha(1, _local_2);
        }

        public function get matrixTransform():Matrix
        {
            var _local_1:Number = (this.scale * Math.cos(this.rotation));
            var _local_2:Number = (this.scale * Math.sin(this.rotation));
            return (new Matrix(_local_1, _local_2, -(_local_2), _local_1, this.x, this.y));
        }

        public function get colorTransform():ColorTransform
        {
            if (this.info.keepColor)
            {
                return (new ColorTransform(1, 1, 1, this.alpha, ((this.color >> 16) & 0xFF), ((this.color >> 8) & 0xFF), (this.color & 0xFF), 0));
            };
            return (new ColorTransform(0, 0, 0, this.alpha, ((this.color >> 16) & 0xFF), ((this.color >> 8) & 0xFF), (this.color & 0xFF), 0));
        }


    }
}//package par.particals

