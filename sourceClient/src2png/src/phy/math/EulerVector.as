// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//phy.math.EulerVector

package phy.math
{
    public class EulerVector 
    {

        public var x0:Number;
        public var x1:Number;
        public var x2:Number;

        public function EulerVector(_arg_1:Number, _arg_2:Number, _arg_3:Number)
        {
            this.x0 = _arg_1;
            this.x1 = _arg_2;
            this.x2 = _arg_3;
        }

        public function clear():void
        {
            this.x0 = 0;
            this.x1 = 0;
            this.x2 = 0;
        }

        public function clearMotion():void
        {
            this.x1 = 0;
            this.x2 = 0;
        }

        public function ComputeOneEulerStep(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):void
        {
            this.x2 = ((_arg_3 - (_arg_2 * this.x1)) / _arg_1);
            this.x1 = (this.x1 + (this.x2 * _arg_4));
            this.x0 = (this.x0 + (this.x1 * _arg_4));
        }

        public function toString():String
        {
            return ((((("x:" + this.x0) + ",v:") + this.x1) + ",a") + this.x2);
        }


    }
}//package phy.math

