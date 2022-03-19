// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//par.enginees.ParticleEnginee

package par.enginees
{
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import par.particals.Particle;
    import par.renderer.IParticleRenderer;
    import par.emitters.Emitter;
    import flash.events.Event;
    import par.particals.ParticleInfo;
    import __AS3__.vec.*;

    public class ParticleEnginee 
    {

        private var _maxCount:int;
        private var _root:Sprite;
        private var _last:int;
        private var _emitters:Dictionary;
        public var spareParticles:Dictionary;
        public var particles:Vector.<Particle>;
        private var _render:IParticleRenderer;
        public var cachable:Boolean = true;

        public function ParticleEnginee(_arg_1:IParticleRenderer)
        {
            this._render = _arg_1;
            this._maxCount = 200;
            this.spareParticles = new Dictionary();
            this.particles = new Vector.<Particle>();
            this._emitters = new Dictionary();
        }

        public function setMaxCount(_arg_1:Number):void
        {
            this._maxCount = _arg_1;
        }

        public function addEmitter(_arg_1:Emitter):void
        {
            this._emitters[_arg_1] = _arg_1;
            _arg_1.setEnginee(this);
        }

        public function removeEmitter(_arg_1:Emitter):void
        {
            delete this._emitters[_arg_1];
            _arg_1.setEnginee(null);
        }

        public function addParticle(_arg_1:Particle):void
        {
            this.particles.push(_arg_1);
            this._render.addParticle(_arg_1);
        }

        private function __enterFrame(_arg_1:Event):void
        {
            this.update();
        }

        public function update():void
        {
            var _local_1:Particle;
            var _local_3:Emitter;
            var _local_4:int;
            while (this.particles.length > this._maxCount)
            {
                _local_1 = this.particles.shift();
                this._render.removeParticle(_local_1);
                this.cacheParticle(_local_1);
            };
            var _local_2:Number = 0.04;
            for each (_local_3 in this._emitters)
            {
                _local_3.execute(_local_3.info.interval);
            };
            _local_4 = 0;
            while (_local_4 < this.particles.length)
            {
                _local_1 = this.particles[_local_4];
                _local_1.age = (_local_1.age + _local_2);
                if (_local_1.age >= _local_1.life)
                {
                    this.particles.splice(_local_4, 1);
                    this._render.removeParticle(_local_1);
                    this.cacheParticle(_local_1);
                    _local_4--;
                }
                else
                {
                    _local_1.update(_local_2);
                };
                _local_4++;
            };
            this._render.renderParticles(this.particles);
        }

        protected function cacheParticle(_arg_1:Particle):void
        {
            _arg_1.initialize();
            var _local_2:uint = _arg_1.info.displayCreator;
            var _local_3:Array = this.spareParticles[_local_2];
            if (_local_3 == null)
            {
                this.spareParticles[_local_2] = (_local_3 = new Array());
            };
            if (_local_3.length < 15)
            {
                _local_3.push(_arg_1);
            };
        }

        public function reset():void
        {
            this.particles = new Vector.<Particle>();
            this.spareParticles = new Dictionary();
            this._emitters = new Dictionary();
            this._render.reset();
        }

        public function createParticle(_arg_1:ParticleInfo):Particle
        {
            if (((this.spareParticles[_arg_1.displayCreator]) && (this.spareParticles[_arg_1.displayCreator].length > 0)))
            {
                return (this.spareParticles[_arg_1.displayCreator].shift());
            };
            return (new Particle(_arg_1));
        }

        public function dispose():void
        {
            this._render.dispose();
        }


    }
}//package par.enginees

