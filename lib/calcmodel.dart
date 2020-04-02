	class CalcModel {
		static const int FN_NOP      = 0;
		static const int FN_ALLCLEAR = 1;
		static const int FN_SIGN     = 2;
		static const int FN_MODULO   = 3;
		static const int FN_DIVIDE   = 4;
		static const int FN_TIMES    = 5;
		static const int FN_MINUS    = 6;
		static const int FN_PLUS     = 7;

		num    _result = 0;
		bool   _isResult = true;
		bool   _isDivByZero = false;
		int    _func = FN_PLUS;
		String _status = "";

		CalcModel() {
			this._result = 0;
			this._isResult = true;
			this._isDivByZero = false;
			this._func = FN_PLUS;
			this._status = "";
		}

		String getAccumulator(String val) {
			var accumulator = "";
			if (val != "") {
				accumulator = val;
			} else {
				accumulator = "0";
			}
			return accumulator;
		}

    num calculateResult(String val) {
			num numVal = num.tryParse(val);

			if (num == null) {
				this.setStatus("Invalid numeric value");
				this._result = 0;
				return 0;
			}

			switch(this._func) {
				case FN_MODULO:
					if (numVal == 0) {
						this._isDivByZero = true;
						this.setStatus("Divide by zero!");
					} else {
						this._result = this._result % numVal;
					}
					break;
				case FN_DIVIDE:
					if (numVal == 0) {
						this._isDivByZero = true;
						this.setStatus("Divide by zero!");
					} else {
						this._result = this._result / numVal;
					}
					break;
				case FN_TIMES:
					this._result = this._result * numVal;
					break;
				case FN_PLUS:
					this._result = this._result + numVal;
					break;
				case FN_MINUS:
					this._result = this._result - numVal;
					break;
				default:
					this.setStatus("Unknown arithmetic operation");
					this._result = 0;
					break;
			}

			//debugPrint("Result is '" + this._result + "'");
			this.setResultTrue();

			return this._result;
		}

    void storeResult(String val) {
			this._result = num.tryParse(val);
		}

    String getResult() {
			return "" + this._result.toString();
		}

    void clearAll() {
			this._result = 0;
			this._isResult = true;
			this._isDivByZero = false;
			this._func = FN_PLUS;
			this._status = "";
		}

    void onModulo() {
  		this._func = FN_MODULO;
  		this._isResult = true;
		}

    void onDivide() {
  		this._func = FN_DIVIDE;
  		this._isResult = true;
		}

    void onTimes() {
  		this._func = FN_TIMES;
  		this._isResult = true;
		}

    void onMinus() {
  		this._func = FN_MINUS;
  		this._isResult = true;
		}

    void onPlus() {
  		this._func = FN_PLUS;
  		this._isResult = true;
		}

    bool isDivideByZero() {
			return this._isDivByZero;
		}

    bool isResult() {
			return this._isResult;
		}

    void setResultFalse() {
			this._isResult = false;
		}

    void setResultTrue() {
			this._isResult = true;
		}

		String getStatus() {
			return this._status;
		}

		void setStatus(String val) {
			this._status = val;
		}
	}

