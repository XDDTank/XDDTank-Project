// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//par.emitters.Emitter

package par.emitters
{
    import flash.events.EventDispatcher;
    import par.enginees.ParticleEnginee;
    import flash.events.Event;
    import par.particals.ParticleInfo;
    import par.particals.Particle;
    import road7th.math.randRange;

    [Event(name="complete", type="flash.events.Event")]
    public class Emitter extends EventDispatcher 
    {

        public var x:Number = 0;
        public var y:Number = 0;
        private var _info:EmitterInfo;
        private var _enginee:ParticleEnginee;
        private var _interval:Number = 0;
        private var _age:Number = 0;
        public var angle:Number = 0;
        public var autoRestart:Boolean = false;

        public function Emitter()
        {
            this._interval = 0;
        }

        public function setEnginee(_arg_1:ParticleEnginee):void
        {
            this._enginee = _arg_1;
        }

        public function restart():void
        {
            this._age = 0;
        }

        public function get info():EmitterInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:EmitterInfo):void
        {
            this._info = _arg_1;
            this._interval = this._info.interval;
        }

        public function execute(_arg_1:Number):void
        {
            if (((this._enginee) && (this.info)))
            {
                this._age = (this._age + _arg_1);
                if (((this.info.life <= 0) || (this._age < this.info.life)))
                {
                    this._interval = (this._interval + _arg_1);
                    if (this._interval > this.info.interval)
                    {
                        this._interval = 0;
                        this.emit();
                    };
                }
                else
                {
                    if (this.autoRestart)
                    {
                        this.restart();
                    }
                    else
                    {
                        this.dispose();
                    };
                };
            };
        }

        public function dispose():void
        {
            this._enginee.removeEmitter(this);
            dispatchEvent(new Event(Event.COMPLETE));
        }

        protected function emit():void
        {
            var _local_1:ParticleInfo;
            var _local_2:int;
            var _local_3:int;
            var _local_4:Particle;
            for each (_local_1 in this.info.particales)
            {
                if (((_local_1.beginTime < this._age) && (_local_1.endTime > this._age)))
                {
                    _local_2 = (_local_1.countOrient + int(randRange(0, _local_1.countSize)));
                    _local_3 = 0;
                    while (_local_3 < _local_2)
                    {
                        _local_4 = this._enginee.createParticle(_local_1);
                        _local_4.life = (_local_1.lifeOrient + randRange(0, _local_1.lifeSize));
                        _local_4.size = (_local_1.sizeOrient + randRange(0, _local_1.sizeSize));
                        _local_4.v = (_local_1.vOrient + randRange(0, _local_1.vSize));
                        _local_4.angle = (this.angle + randRange(this.info.beginAngle, this.info.endAngle));
                        _local_4.motionV = (_local_1.motionVOrient + randRange(0, _local_1.motionVOrient));
                        _local_4.weight = (_local_1.weightOrient + randRange(0, _local_1.weightSize));
                        _local_4.spin = (_local_1.spinOrient + randRange(0, _local_1.spinSize));
                        _local_4.rotation = (_local_1.rotation + this.angle);
                        _local_4.x = this.x;
                        _local_4.y = this.y;
                        _local_4.color = _local_1.colorOrient;
                        _local_4.alpha = _local_1.alphaOrient;
                        this._enginee.addParticle(_local_4);
                        _local_3++;
                    };
                };
            };
        }


    }
}//package par.emitters

