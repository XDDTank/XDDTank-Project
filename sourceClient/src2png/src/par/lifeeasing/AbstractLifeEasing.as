// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//par.lifeeasing.AbstractLifeEasing

package par.lifeeasing
{
    import road7th.math.XLine;
    import road7th.math.ColorLine;

    public class AbstractLifeEasing 
    {

        public var vLine:XLine = new XLine();
        public var rvLine:XLine = new XLine();
        public var spLine:XLine = new XLine();
        public var sizeLine:XLine = new XLine();
        public var weightLine:XLine = new XLine();
        public var alphaLine:XLine = new XLine();
        public var colorLine:ColorLine;


        public function easingVelocity(_arg_1:Number, _arg_2:Number):Number
        {
            return (_arg_1 * this.vLine.interpolate(_arg_2));
        }

        public function easingRandomVelocity(_arg_1:Number, _arg_2:Number):Number
        {
            return (_arg_1 * this.rvLine.interpolate(_arg_2));
        }

        public function easingSize(_arg_1:Number, _arg_2:Number):Number
        {
            return (_arg_1 * this.sizeLine.interpolate(_arg_2));
        }

        public function easingSpinVelocity(_arg_1:Number, _arg_2:Number):Number
        {
            return (_arg_1 * this.spLine.interpolate(_arg_2));
        }

        public function easingWeight(_arg_1:Number, _arg_2:Number):Number
        {
            return (_arg_1 * this.weightLine.interpolate(_arg_2));
        }

        public function easingColor(_arg_1:uint, _arg_2:Number):uint
        {
            if (this.colorLine)
            {
                return (this.colorLine.interpolate(_arg_2));
            };
            return (_arg_1);
        }

        public function easingApha(_arg_1:Number, _arg_2:Number):Number
        {
            return (_arg_1 * this.alphaLine.interpolate(_arg_2));
        }


    }
}//package par.lifeeasing

