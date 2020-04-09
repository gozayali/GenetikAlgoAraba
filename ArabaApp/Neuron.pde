class Neuron
{
  int[] inputs = new int[5];
  double[] weights = new double[5];
  double biasWeight;
  double output;

  public Neuron() {
    biasWeight=random(1);
    for (int i=0; i<inputs.length; i++)
      weights[i]=random(1);
  }

  public double getOutput()
  {
    double sum=0;
    for (int i=0; i<inputs.length; i++)
      sum+= weights[i] * inputs[i];
    sum+= biasWeight;
    output=sigmoidValue(sum);
    return output;
  }
}
